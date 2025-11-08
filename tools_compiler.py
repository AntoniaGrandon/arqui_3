import sys
import re
from collections import namedtuple

class Var:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Var({self.name})"

class Num:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return f"Num({self.value})"

class BinOp:
    def __init__(self, op, left, right):
        self.op = op
        self.left = left
        self.right = right
    def __repr__(self):
        return f"BinOp({self.op}, {self.left}, {self.right})"

class Parser:
    def __init__(self, s):
        self.s = s
        self.pos = 0

    def peek(self):
        if self.pos >= len(self.s): return ''
        return self.s[self.pos]

    def consume(self, expected=None):
        if expected:
            assert self.s[self.pos:self.pos+len(expected)] == expected
            self.pos += len(expected)
            return expected
        ch = self.s[self.pos]
        self.pos += 1
        return ch

    def skip_ws(self):
        while self.peek() and self.peek().isspace():
            self.pos += 1

    def parse_expr(self):
        self.skip_ws()
        node = self.parse_term()
        while True:
            self.skip_ws()
            if self.s[self.pos:self.pos+1] == '+':
                self.pos += 1
                right = self.parse_term()
                node = BinOp('+', node, right)
            elif self.s[self.pos:self.pos+1] == '-':
                self.pos += 1
                right = self.parse_term()
                node = BinOp('-', node, right)
            else:
                break
        return node

    def parse_term(self):
        self.skip_ws()
        ch = self.peek()
        if ch == '(':
            self.consume('(')
            node = self.parse_expr()
            self.skip_ws()
            if self.peek() == ')':
                self.consume(')')
            else:
                raise SyntaxError('Missing )')
            return node
        m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", self.s[self.pos:])
        if m:
            name = m.group(0)
            self.pos += len(name)
            return Var(name)
        m = re.match(r"[0-9]+", self.s[self.pos:])
        if m:
            val = int(m.group(0))
            self.pos += len(m.group(0))
            return Num(val)
        raise SyntaxError(f"Unexpected char at {self.pos}: '{self.peek()}'")

class CodeGen:
    def __init__(self):
        self.code = []
        self.mem_accesses = 0
        self.tmp_idx = 0
        self.temps = []

    def emit(self, line):
        self.code.append(line)

    def gen(self, node, data_names):
        valid_names, short_map = data_names
        if isinstance(node, Num):
            self.emit(f"MOV A, #{node.value}    ; load immediate")
            return
        if isinstance(node, Var):
            varname = None
            if node.name in valid_names:
                varname = node.name
            elif node.name in short_map:
                varname = short_map[node.name]
            else:
                raise ValueError(f"Unknown variable {node.name}")
            self.emit(f"MOV A, ({varname})")
            self.mem_accesses += 1
            return
        if isinstance(node, BinOp):
            self.gen(node.right, data_names)
            self.emit("MOV B, A")
            self.emit("PUSH B")
            self.mem_accesses += 1 
            self.gen(node.left, data_names)
            self.emit("POP B")
            self.mem_accesses += 1 
            if node.op == '+':
                self.emit("ADD A, B")
            elif node.op == '-':
                self.emit("SUB A, B")
            else:
                raise ValueError(f"Operator {node.op} not supported in partial deliverable")
            return
        raise ValueError(f"Unknown node type: {node}")

def parse_input_text(text):
    m = re.search(r"DATA:\s*(.*?)\n\n", text, re.S)
    data_block = ''
    if m:
        data_block = m.group(1)
    else:
        if 'DATA:' in text:
            start = text.index('DATA:')+5
            rest = text[start:]
            parts = re.split(r"\n\s*\n", rest, 1)
            data_block = parts[0]
    data = {}
    short_map = {}
    for line in data_block.splitlines():
        line = line.strip()
        if not line: continue
        parts = line.split()
        if len(parts) >= 2:
            name = parts[0]
            val = int(parts[1])
            data[name] = val
            m = re.match(r"v_(.+)", name)
            if m:
                short = m.group(1)
                short_map[short] = name
    m2 = re.search(r"result\s*=\s*(.*)", text)
    if not m2:
        m3 = re.search(r"EXPR:\s*(.*)", text, re.S)
        if m3:
            expr = m3.group(1).strip()
        else:
            raise ValueError('No expression found (line with "result = ...")')
    else:
        expr = m2.group(1).strip()
    return data, expr, short_map

def compile_from_text(text):
    data, expr, short_map = parse_input_text(text)
    parser = Parser(expr)
    ast = parser.parse_expr()
    cg = CodeGen()
    cg.emit("MOV A, 0 ")
    cg.emit("MOV (error), A")
    cg.emit("MOV (result), A")
    cg.mem_accesses += 2
    valid_names = set(data.keys())
    cg.gen(ast, (valid_names, short_map))
    cg.emit("MOV (result), A")
    cg.mem_accesses += 1
    combined_data = data.copy()
    for t in getattr(cg, 'temps', []):
        if t not in combined_data:
            combined_data[t] = 0
    data_lines = ["DATA:"]
    for k, v in combined_data.items():
        data_lines.append(f"{k} {v}")
    data_lines.append("")
    data_lines.append("CODE:")
    code_lines = data_lines + cg.code

    return code_lines, len(cg.code), cg.mem_accesses

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python tools_compiler.py input.txt')
        sys.exit(1)
    fn = sys.argv[1]
    with open(fn, 'r', encoding='utf-8') as f:
        text = f.read()
    asm, lines, memacc = compile_from_text(text)
    print('\n'.join(asm))
    print('\n; lines =', lines, ' memory_accesses =', memacc)

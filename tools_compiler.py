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
    
class FuncCall: #Clase para manejar FUNCIONES recién añadidas -Sofi
    def __init__(self, name, args):
        self.name = name
        self.args = args
    def __repr__(self):
        return f"FuncCall({self.name}, {self.args})"

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

    def parse_expr(self): #Para SUMAS y RESTAS (lo cambie un poco) -Sofi (pd: porque sigo intentando escribir los comentarios con //, triste)
        self.skip_ws()
        node = self.parse_mul()

        while True:
            self.skip_ws()
            if self.s[self.pos:self.pos+1] == '+':
                self.pos += 1
                #Aquí cambie el right de self.parse_term() a self.parse_mul() para que priorice *, / y %
                right = self.parse_mul()

                node = BinOp('+', node, right)

            elif self.s[self.pos:self.pos+1] == '-':
                self.pos += 1
                #Aquí cambie el right de self.parse_term() a self.parse_mul() por lo mismo
                right = self.parse_mul()

                node = BinOp('-', node, right)

            else:
                break

        return node
    
    def parse_mul(self): #Añadi esto para MULTIPLICACIÓN(*), DIVISIÓN(/) y DIVISIÓN ENTERA(%) - Sofi
        #Operadores ∗, / y % (1.5 puntos) listoooos - Sofi
        node = self.parse_term()
        while True:
            self.skip_ws()
            if self.peek() == '*':
                self.consume('*')
                node = BinOp('*', node, self.parse_term())
            elif self.peek() == '/':
                self.consume('/')
                node = BinOp('/', node, self.parse_term())
            elif self.peek() == '%':
                self.consume('%')
                node = BinOp('%', node, self.parse_term())
            else:
                break
        return node
    
    def parse_term(self): #para las VARIABLES, los VALORES NUMERICOS y PARENTESIS -Sofi (pd: mald!%#tos # para comentar, debimos hacerlo en C o C++)
        self.skip_ws()
        ch = self.peek()
        
        if ch == '(':
            self.consume('(') #para los PARENTESIS (hecho por anto) -Sofi
            node = self.parse_expr()
            self.skip_ws()
            if self.peek() == ')':
                self.consume(')')
            else:
                raise SyntaxError('Missing )')
            return node
        
        m = re.match(r"(max|min|abs)", self.s[self.pos:]) #para FUNCIONES: MAX, MIN y ABS (hecho por Sofi) -Sofi
        if m:
            fname = m.group(0)
            self.pos += len(fname)

            self.skip_ws()
            self.consume('(')

            arg1 = self.parse_expr()
            if fname in ("max", "min"):  #FUNCIONES BINARIAS MAXIMO Y MINIMO -Sofi (pd: extraño los {} de C y C++)
                self.skip_ws()
                self.consume(',')
                arg2 = self.parse_expr()
                self.skip_ws()
                self.consume(')')
                return BinOp(fname, arg1, arg2)
            else:  #VALOR ABSOLUTO -Sofi
                self.skip_ws()
                self.consume(')')
                return BinOp(fname, arg1, None)
        
        m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", self.s[self.pos:]) #para las VARIABLES (hecho por Anto) -Sofi
        if m:
            name = m.group(0)
            self.pos += len(name)
            return Var(name)
        
        m = re.match(r"[0-9]+", self.s[self.pos:]) #para VALORES NUMERICOS (hecho por Anto) -Sofi
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
                self.emit("JO error_overflow") #Añadido para revisar Overflow -Sofi
            elif node.op == '-':
                self.emit("SUB A, B")
                self.emit("JO error_overflow") #Añadido para revisar Overflow -Sofi
            elif node.op == '*': #Añadido para implementar lo que nos piden en la Entrega Final -Sofi
                self.emit("MUL A, B")
                self.emit("JO error_overflow") #Añadido para revisar Overflow -Sofi
            elif node.op == '/':
                self.emit("CMP B, 0")
                self.emit("JE error_div_zero") #Añadido para revisar si se hizo División por 0 -Sofi
                self.emit("DIV A, B")
                self.emit("JO error_overflow") #Añadido para revisar Overflow -Sofi
            elif node.op == '%':
                self.emit("CMP B, 0")
                self.emit("JE error_div_zero") #Añadido para revisar si se hizo División por 0 -Sofi
                self.emit("MOD A, B")
                self.emit("JO error_overflow") #Añadido para revisar Overflow -Sofi
            elif node.op == 'max': # Implementación para MAX -Sofi
                label_end = f"L{self.tmp_idx}_MAX_END"
                self.tmp_idx += 1
                
                self.emit(f"CMP A, B")
                self.emit(f"JGE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"{label_end}:")
                
            elif node.op == 'min': # Implementación para MIN -Sofi
                label_end = f"L{self.tmp_idx}_MIN_END"
                self.tmp_idx += 1
                
                self.emit(f"CMP A, B")
                self.emit(f"JLE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"{label_end}:")

            elif node.op == 'abs': # Implementación para ABS -Sofi (pd: Anto si quieres de ahí borra mis comentarios,
                # la verdad no son muy profesionales jiji, pero encuentro que por lo menos así no me pierdo :( )
                label_end = f"L{self.tmp_idx}_ABS_END"
                self.tmp_idx += 1
                
                self.emit(f"CMP A, 0")
                self.emit(f"JGE {label_end}")
                self.emit(f"NEG A") 
                self.emit(f"{label_end}:")
            else:
                raise ValueError(f"Operator {node.op} not supported")
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

    cg.emit("JMP end")

    cg.emit("error_div_zero:")
    cg.emit("MOV A, 1")
    cg.emit("MOV (error), A")
    cg.emit("MOV A, 0")
    cg.emit("MOV (result), A")
    cg.emit("JMP end")

    cg.emit("error_overflow:")
    cg.emit("MOV A, 1")
    cg.emit("MOV (error), A")
    cg.emit("MOV A, 0")
    cg.emit("MOV (result), A")
    cg.emit("JMP end")

    cg.emit("end:")

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

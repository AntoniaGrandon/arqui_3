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
            self.emit(f"MOV A, {node.value}")
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
            if node.op == 'abs':
                self.gen(node.left, data_names)
                label_end = f"L{self.tmp_idx}_ABS_END"
                self.tmp_idx += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {label_end}")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"{label_end}:")
                return

            self.gen(node.right, data_names)
            self.emit("MOV B, A")
            self.emit("PUSH B")
            self.mem_accesses += 1
            self.gen(node.left, data_names)
            self.emit("POP B")
            self.mem_accesses += 1
    
            if node.op == '+':
                idx = self.tmp_idx
                self.tmp_idx += 1
                tmp_left = f"tmp_add_left_{idx}"
                tmp_right = f"tmp_add_right_{idx}"
                self.temps.append(tmp_left)
                self.temps.append(tmp_right)

                L_A_POS = f"L{idx}_ADD_A_POS"
                L_A_NEG = f"L{idx}_ADD_A_NEG"
                L_SKIP = f"L{idx}_ADD_SKIP"
                L_AFTER = f"L{idx}_ADD_AFTER"

                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_A_POS}")

                self.emit(f"{L_A_NEG}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JLT {L_SKIP}")
                self.emit(f"MOV A, -128")
                self.emit(f"SUB A, B")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, B")
                self.emit(f"JLT error_overflow")
                self.emit(f"MOV B, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"JMP {L_AFTER}")

                self.emit(f"{L_A_POS}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JGE {L_SKIP}")
                self.emit(f"MOV A, 127")
                self.emit(f"SUB A, B")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, B")
                self.emit(f"JGT error_overflow")
                self.emit(f"MOV B, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"JMP {L_AFTER}")

                self.emit(f"{L_SKIP}:")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"{L_AFTER}:")

            elif node.op == '-':
                idx = self.tmp_idx
                self.tmp_idx += 1
                tmp_left = f"tmp_sub_left_{idx}"
                tmp_right = f"tmp_sub_right_{idx}"
                self.temps.append(tmp_left)
                self.temps.append(tmp_right)

                L_A_POS = f"L{idx}_SUB_A_POS"
                L_A_NEG = f"L{idx}_SUB_A_NEG"
                L_SKIP = f"L{idx}_SUB_SKIP"
                L_AFTER = f"L{idx}_SUB_AFTER"

                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1

                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"SUB A, B")
                tmp_result_val = f"tmp_sub_result_{idx}"
                self.temps.append(tmp_result_val)
                self.emit(f"MOV ({tmp_result_val}), A")
                self.mem_accesses += 1

                tmp_flag_res = f"tmp_sub_res_sign_{idx}"
                tmp_flag_left = f"tmp_sub_left_sign_{idx}"
                tmp_flag_right = f"tmp_sub_right_sign_{idx}"
                self.temps.append(tmp_flag_res)
                self.temps.append(tmp_flag_left)
                self.temps.append(tmp_flag_right)

                L_RES_POS = f"L{idx}_SUB_RES_POS"
                L_RES_DONE = f"L{idx}_SUB_RES_DONE"
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_RES_POS}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_res}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_RES_DONE}")
                self.emit(f"{L_RES_POS}:")
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_res}), A")
                self.mem_accesses += 1
                self.emit(f"{L_RES_DONE}:")

                L_LEFT_POS = f"L{idx}_SUB_LEFT_POS"
                L_LEFT_DONE = f"L{idx}_SUB_LEFT_DONE"
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_LEFT_POS}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_LEFT_DONE}")
                self.emit(f"{L_LEFT_POS}:")
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"{L_LEFT_DONE}:")

                L_RIGHT_POS = f"L{idx}_SUB_RIGHT_POS"
                L_RIGHT_DONE = f"L{idx}_SUB_RIGHT_DONE"
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_RIGHT_POS}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_RIGHT_DONE}")
                self.emit(f"{L_RIGHT_POS}:")
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"{L_RIGHT_DONE}:")

                self.emit(f"MOV A, ({tmp_flag_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_flag_right})")
                self.mem_accesses += 1
                self.emit("CMP A, B")
                L_NO_OVF = f"L{idx}_SUB_NO_OVF"
                self.emit(f"JEQ {L_NO_OVF}")

                self.emit(f"MOV A, ({tmp_flag_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_flag_res})")
                self.mem_accesses += 1
                self.emit("CMP A, B")
                self.emit(f"JEQ {L_NO_OVF}")

                self.emit(f"JMP error_overflow")

                self.emit(f"{L_NO_OVF}:")
                self.emit(f"MOV A, ({tmp_result_val})")
                self.mem_accesses += 1

            elif node.op == '*':
                # Robust multiplication using only memory temporaries (no PUSH/POP)
                # Save operands to temporaries, compute absolute values there,
                # perform repeated addition using the temporaries, then apply sign.
                tmp_res = f"tmp_mul_{self.tmp_idx}"
                tmp_left = f"tmp_mul_left_{self.tmp_idx}"
                tmp_right = f"tmp_mul_right_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_res, tmp_left, tmp_right])

                label_mul = f"MUL_{self.tmp_idx}"
                label_end = f"END_MUL_{self.tmp_idx}"
                self.tmp_idx += 1

                tmp_flag_left = f"tmp_mul_left_sign_{self.tmp_idx}"
                tmp_flag_right = f"tmp_mul_right_sign_{self.tmp_idx}"
                tmp_sign = f"tmp_mul_sign_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_flag_left, tmp_flag_right, tmp_sign])

                # store operands into memory (A=left, B=right)
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1

                # compute abs(left) into tmp_left and flag
                L_LEFT_NEG = f"L{self.tmp_idx}_MUL_LEFT_NEG"
                L_LEFT_DONE = f"L{self.tmp_idx}_MUL_LEFT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_LEFT_NEG}")
                # negative
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_LEFT_DONE}")
                self.emit(f"{L_LEFT_NEG}:")
                # non-negative
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"{L_LEFT_DONE}:")

                # compute abs(right) into tmp_right and flag
                L_RIGHT_NEG = f"L{self.tmp_idx}_MUL_RIGHT_NEG"
                L_RIGHT_DONE = f"L{self.tmp_idx}_MUL_RIGHT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_RIGHT_NEG}")
                # negative
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_right}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_RIGHT_DONE}")
                self.emit(f"{L_RIGHT_NEG}:")
                # non-negative
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"{L_RIGHT_DONE}:")

                # zero result
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_res}), A")
                self.mem_accesses += 1

                # compute sign = flag_left xor flag_right
                L_SIGN_NO = f"L{self.tmp_idx}_MUL_SIGN_NO"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_flag_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_flag_right})")
                self.mem_accesses += 1
                self.emit("CMP A, B")
                self.emit(f"JEQ {L_SIGN_NO}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_sign}), A")
                self.mem_accesses += 1
                self.emit(f"{L_SIGN_NO}:")

                # multiplication loop: add abs(left) tmp_right times
                # Use memory-held counter ({tmp_right}) to avoid clobbering register B
                self.emit(f"{label_mul}:")
                # load loop counter from memory into A and test for zero
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit("CMP A, 0")
                self.emit(f"JEQ {label_end}")

                # Check overflow for A = ({tmp_res}) + ({tmp_left}) before performing it
                chk_idx = self.tmp_idx
                self.tmp_idx += 1
                L_A_POS = f"L{chk_idx}_MULCHK_A_POS"
                L_A_NEG = f"L{chk_idx}_MULCHK_A_NEG"
                L_SKIP = f"L{chk_idx}_MULCHK_SKIP"
                L_AFTER = f"L{chk_idx}_MULCHK_AFTER"

                # load operands into A and B for the overflow check
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_left})")
                self.mem_accesses += 1

                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_A_POS}")

                self.emit(f"{L_A_NEG}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JLT {L_SKIP}")
                self.emit(f"MOV A, -128")
                self.emit(f"SUB A, B")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                self.emit(f"CMP A, B")
                self.emit(f"JLT error_overflow")
                self.emit(f"MOV B, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"JMP {L_AFTER}")

                self.emit(f"{L_A_POS}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JGE {L_SKIP}")
                self.emit(f"MOV A, 127")
                self.emit(f"SUB A, B")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                self.emit(f"CMP A, B")
                self.emit(f"JGT error_overflow")
                self.emit(f"MOV B, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"JMP {L_AFTER}")

                self.emit(f"{L_SKIP}:")
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"ADD A, B")
                self.emit(f"{L_AFTER}:")

                # store back and continue loop
                self.emit(f"MOV ({tmp_res}), A")
                self.mem_accesses += 1
                # decrement the memory-held counter ({tmp_right}) and loop
                self.emit(f"MOV B, ({tmp_right})")
                self.mem_accesses += 1
                self.emit("SUB B, 1")
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1
                self.emit(f"JMP {label_mul}")

                self.emit(f"{label_end}:")
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1

                # apply sign if needed
                L_NO_NEG = f"L{self.tmp_idx}_MUL_NO_NEG"
                self.tmp_idx += 1
                self.emit(f"MOV B, ({tmp_sign})")
                self.mem_accesses += 1
                self.emit(f"CMP B, 0")
                self.emit(f"JEQ {L_NO_NEG}")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"{L_NO_NEG}:")
                return
            
            elif node.op == '/':
                # Division with sign handling (C-like): quotient truncated toward zero,
                # remainder has the sign of the numerator.
                tmp_res = f"tmp_div_{self.tmp_idx}"
                tmp_left = f"tmp_div_left_{self.tmp_idx}"
                tmp_right = f"tmp_div_right_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_res, tmp_left, tmp_right])

                # flags for signs
                tmp_flag_left = f"tmp_div_left_sign_{self.tmp_idx}"
                tmp_flag_right = f"tmp_div_right_sign_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_flag_left, tmp_flag_right])

                label_div = f"DIV_{self.tmp_idx}"
                label_end = f"END_DIV_{self.tmp_idx}"
                self.tmp_idx += 1

                # store operands (A=left, B=right)
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1

                # compute sign and abs(left)
                L_LEFT_NEG = f"L{self.tmp_idx}_DIV_LEFT_NEG"
                L_LEFT_DONE = f"L{self.tmp_idx}_DIV_LEFT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_LEFT_NEG}")
                # negative
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_LEFT_DONE}")
                self.emit(f"{L_LEFT_NEG}:")
                # non-negative
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"{L_LEFT_DONE}:")

                # compute sign and abs(right)
                L_RIGHT_NEG = f"L{self.tmp_idx}_DIV_RIGHT_NEG"
                L_RIGHT_DONE = f"L{self.tmp_idx}_DIV_RIGHT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_RIGHT_NEG}")
                # negative
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_right}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_RIGHT_DONE}")
                self.emit(f"{L_RIGHT_NEG}:")
                # non-negative
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"{L_RIGHT_DONE}:")

                # check division by zero (abs right)
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 0")
                self.emit(f"JEQ error_div_zero")

                # zero quotient
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_res}), A")
                self.mem_accesses += 1

                # division loop using positive operands: subtract tmp_right from tmp_left
                self.emit(f"{label_div}:")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, ({tmp_right})")
                self.emit(f"JLT {label_end}")

                self.emit(f"SUB A, ({tmp_right})")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1

                self.emit(f"MOV A, ({tmp_res})")
                self.emit(f"ADD A, 1")
                self.emit(f"MOV ({tmp_res}), A")
                self.mem_accesses += 2

                self.emit(f"JMP {label_div}")

                self.emit(f"{label_end}:")
                # apply sign to quotient if flags differ
                L_NO_NEG = f"L{self.tmp_idx}_DIV_NO_NEG"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_flag_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, ({tmp_flag_right})")
                self.mem_accesses += 1
                self.emit("CMP A, B")
                self.emit(f"JEQ {L_NO_NEG}")

                # negate tmp_res
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_res}), A")
                self.mem_accesses += 1

                self.emit(f"{L_NO_NEG}:")
                self.emit(f"MOV A, ({tmp_res})")
                self.mem_accesses += 1
                return

            elif node.op == '%':
                # Modulo with sign handling: remainder has sign of numerator (left),
                # computed as abs(left) % abs(right) then apply sign of left.
                tmp_res = f"tmp_mod_res_{self.tmp_idx}"
                tmp_left = f"tmp_mod_left_{self.tmp_idx}"
                tmp_right = f"tmp_mod_right_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_res, tmp_left, tmp_right])

                tmp_flag_left = f"tmp_mod_left_sign_{self.tmp_idx}"
                tmp_flag_right = f"tmp_mod_right_sign_{self.tmp_idx}"
                self.tmp_idx += 1
                self.temps.extend([tmp_flag_left, tmp_flag_right])

                label_div = f"MOD_DIV_{self.tmp_idx}"
                label_end = f"END_MOD_{self.tmp_idx}"
                self.tmp_idx += 1

                # store operands
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV ({tmp_right}), B")
                self.mem_accesses += 1

                # compute sign and abs(left)
                L_LEFT_NEG = f"L{self.tmp_idx}_MOD_LEFT_NEG"
                L_LEFT_DONE = f"L{self.tmp_idx}_MOD_LEFT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_LEFT_NEG}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_LEFT_DONE}")
                self.emit(f"{L_LEFT_NEG}:")
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_left}), A")
                self.mem_accesses += 1
                self.emit(f"{L_LEFT_DONE}:")

                # compute sign and abs(right)
                L_RIGHT_NEG = f"L{self.tmp_idx}_MOD_RIGHT_NEG"
                L_RIGHT_DONE = f"L{self.tmp_idx}_MOD_RIGHT_DONE"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_RIGHT_NEG}")
                self.emit(f"MOV A, 1")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_right}), A")
                self.mem_accesses += 1
                self.emit(f"JMP {L_RIGHT_DONE}")
                self.emit(f"{L_RIGHT_NEG}:")
                self.emit(f"MOV A, 0")
                self.emit(f"MOV ({tmp_flag_right}), A")
                self.mem_accesses += 1
                self.emit(f"{L_RIGHT_DONE}:")

                # check division by zero (abs right)
                self.emit(f"MOV A, ({tmp_right})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 0")
                self.emit(f"JEQ error_div_zero")

                # modulo loop: subtract tmp_right from tmp_left until less than
                self.emit(f"{label_div}:")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, ({tmp_right})")
                self.emit(f"JLT {label_end}")

                self.emit(f"SUB A, ({tmp_right})")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1

                self.emit(f"JMP {label_div}")

                self.emit(f"{label_end}:")
                # result in tmp_left (abs remainder); apply sign of original left
                L_NO_NEG = f"L{self.tmp_idx}_MOD_NO_NEG"
                self.tmp_idx += 1
                self.emit(f"MOV A, ({tmp_flag_left})")
                self.mem_accesses += 1
                self.emit(f"CMP A, 0")
                self.emit(f"JEQ {L_NO_NEG}")

                # negate remainder
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"MOV ({tmp_left}), A")
                self.mem_accesses += 1

                self.emit(f"{L_NO_NEG}:")
                self.emit(f"MOV A, ({tmp_left})")
                self.mem_accesses += 1
                return

            elif node.op == 'max': # Implementación para MAX -Sofi
                idx = self.tmp_idx
                label_end = f"L{idx}_MAX_END"
                L_A_POS = f"L{idx}_MAX_A_POS"
                label_take_b = f"L{idx}_MAX_TAKEB"
                self.tmp_idx += 1

                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_A_POS}")
                self.emit(f"CMP B, 128")
                self.emit(f"JLT {label_take_b}")
                self.emit(f"CMP A, B")
                self.emit(f"JGE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"JMP {label_end}")
                self.emit(f"{label_take_b}:")
                self.emit(f"MOV A, B")
                self.emit(f"JMP {label_end}")

                self.emit(f"{L_A_POS}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JGE {label_end}")
                self.emit(f"CMP A, B")
                self.emit(f"JGE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"{label_end}:")
                
            elif node.op == 'min': # Implementación para MIN -Sofi
                label_end = f"L{self.tmp_idx}_MIN_END"
                L_A_POS = f"L{self.tmp_idx}_MIN_A_POS"
                self.tmp_idx += 1

                self.emit(f"CMP A, 128")
                self.emit(f"JLT {L_A_POS}")
                self.emit(f"CMP B, 128")
                self.emit(f"JLT {label_end}")
                self.emit(f"CMP A, B")
                self.emit(f"JLE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"JMP {label_end}")

                self.emit(f"{L_A_POS}:")
                self.emit(f"CMP B, 128")
                self.emit(f"JGE {label_end}")
                self.emit(f"CMP A, B")
                self.emit(f"JLE {label_end}")
                self.emit(f"MOV A, B")
                self.emit(f"{label_end}:")

            elif node.op == 'abs': # Implementación para ABS -Sofi (pd: Anto si quieres de ahí borra mis comentarios,
                # la verdad no son muy profesionales jiji, pero encuentro que por lo menos así no me pierdo :( )
                label_end = f"L{self.tmp_idx}_ABS_END"
                self.tmp_idx += 1
                
                self.emit(f"CMP A, 128")
                self.emit(f"JLT {label_end}")
                self.emit(f"MOV B, A")
                self.emit(f"MOV A, 0")
                self.emit(f"SUB A, B")
                self.emit(f"{label_end}:")
            else:
                raise ValueError(f"Operator {node.op} not supported")
            return
        raise ValueError(f"Unknown node type: {node}")

def parse_input_text(text):
    # Find DATA block: accept either LF or CRLF blank line separators
    m = re.search(r"DATA:\s*(.*?)\r?\n\r?\n", text, re.S)
    data_block = ''
    if m:
        data_block = m.group(1)
    else:
        if 'DATA:' in text:
            start = text.index('DATA:')+5
            rest = text[start:]
            parts = re.split(r"\r?\n\s*\r?\n", rest, 1)
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
                
    # Extract expression: prefer explicit 'result = ...' lines; otherwise use EXPR: block
    # Prefer a standalone line starting with 'result = ...' (anchored to line start)
    # This avoids accidentally matching occurrences inside comments like
    # '# ... result=0 (overflow)'. Use multiline anchor so we only capture
    # the intended expression line.
    m = re.search(r"(?m)^\s*result\s*=\s*(.+)$", text)
    if m:
        expr = m.group(1).strip()
    else:
        m3 = re.search(r"EXPR:\s*(.*)", text, re.S)
        if m3:
            rest = m3.group(1)
            expr = None
            for line in rest.splitlines():
                line = line.strip()
                if not line:
                    continue
                if line.startswith('#'):
                    continue
                expr = line
                break
            if expr is None:
                raise ValueError('No expression found after EXPR:')
        else:
            raise ValueError('No expression found (line with "result = ...")')
    return data, expr, short_map

def compile_from_text(text):
    data, expr, short_map = parse_input_text(text)
    parser = Parser(expr)
    ast = parser.parse_expr()

    cg = CodeGen()
    cg.emit("MOV A, 0")
    cg.emit("MOV (error), A")
    cg.emit("MOV (result), A")
    cg.mem_accesses += 2

    valid_names = set(data.keys())

    cg.gen(ast, (valid_names, short_map))
    cg.emit("MOV (result), A")
    cg.mem_accesses += 1

    cg.emit("JMP end")

    # Emitir manejadores de error/end solo si no fueron generados ya
    if not any(line.strip() == "error_div_zero:" for line in cg.code):
        cg.emit("error_div_zero:")
        cg.emit("MOV A, 1")
        cg.emit("MOV (error), A")
        cg.emit("MOV A, 0")
        cg.emit("MOV (result), A")
        cg.emit("JMP end")

    if not any(line.strip() == "error_overflow:" for line in cg.code):
        cg.emit("error_overflow:")
        cg.emit("MOV A, 1")
        cg.emit("MOV (error), A")
        cg.emit("MOV A, 0")
        cg.emit("MOV (result), A")
        cg.emit("JMP end")

    if not any(line.strip() == "end:" for line in cg.code):
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

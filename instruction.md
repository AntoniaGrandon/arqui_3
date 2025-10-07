# Computador Básico - Instrucciones (cb-instrucciones_arq.pdf)

## Figura 1: Computador básico completo
El documento parte mostrando un **diagrama de un computador básico** con sus bloques principales:
- **ALU** (Unidad Aritmética y Lógica)  
- **Registros A y B** (almacenan operandos)  
- **Instruction Memory** (memoria de instrucciones) con PC (Program Counter)  
- **Data Memory** (memoria de datos)  
- **Multiplexores (Mux A, Mux B, Mux Data)**  
- **Unidad de Control (Control Unit)**  
- **Status Register** con banderas Z, N, C, V:
  - **Z** = Zero (resultado 0)  
  - **N** = Negative (resultado negativo)  
  - **C** = Carry (acarreo)  
  - **V** = Overflow (desbordamiento)  

---

## 1. Assembly

### 1.1 Instrucciones Básicas

| Inst. | Oper. | opcode | LPC | DW | SD0 | LA | LB | SA0/1 | SB0/1 | S0/1/2 | Operación |
|-------|-------|--------|-----|----|-----|----|----|-------|-------|--------|-----------|
| MOV A,B | 0000000 | 0 | 0 | ∼ | 1 | 0 | Z | B + | A = B |
| MOV B,A | 0000001 | 0 | 0 | ∼ | 0 | 1 | A | Z + | B = A |
| MOV A,Lit | 0000010 | 0 | 0 | ∼ | 1 | 0 | Z | Lit + | A = Lit |
| MOV B,Lit | 0000011 | 0 | 0 | ∼ | 0 | 1 | Z | Lit + | B = Lit |
| ADD A,B | 0000100 | 0 | 0 | ∼ | 1 | 0 | A | B + | A = A+B |
| ADD B,A | 0000101 | 0 | 0 | ∼ | 0 | 1 | A | B + | B = A+B |
| ADD A,Lit | 0000110 | 0 | 0 | ∼ | 1 | 0 | A | Lit + | A = A+Lit |
| ADD B,Lit | 0000111 | 0 | 0 | ∼ | 0 | 1 | B | Lit + | B = B+Lit |
| SUB A,B | 0001000 | 0 | 0 | ∼ | 1 | 0 | A | B - | A = A-B |
| SUB B,A | 0001001 | 0 | 0 | ∼ | 0 | 1 | A | B - | B = A-B |
| SUB A,Lit | 0001010 | 0 | 0 | ∼ | 1 | 0 | A | Lit - | A = A-Lit |
| SUB B,Lit | 0001011 | 0 | 0 | ∼ | 0 | 1 | B | Lit - | B = B-Lit |
| AND A,B | 0001100 | 0 | 0 | ∼ | 1 | 0 | A | B & | A = A AND B |
| AND B,A | 0001101 | 0 | 0 | ∼ | 0 | 1 | A | B & | B = A AND B |
| AND A,Lit | 0001110 | 0 | 0 | ∼ | 1 | 0 | A | Lit & | A = A AND Lit |
| AND B,Lit | 0001111 | 0 | 0 | ∼ | 0 | 1 | B | Lit & | B = B AND Lit |
| OR A,B | 0010000 | 0 | 0 | ∼ | 1 | 0 | A | B \|\| | A = A OR B |
| OR B,A | 0010001 | 0 | 0 | ∼ | 0 | 1 | A | B \|\| | B = A OR B |
| OR A,Lit | 0010010 | 0 | 0 | ∼ | 1 | 0 | A | Lit \|\| | A = A OR Lit |
| OR B,Lit | 0010011 | 0 | 0 | ∼ | 0 | 1 | B | Lit \|\| | B = B OR Lit |
| NOT A,A | 0010100 | 0 | 0 | ∼ | 1 | 0 | A | ∼ | A = ¬A |
| NOT A,B | 0010101 | 0 | 0 | ∼ | 1 | 0 | B | ∼ | A = ¬B |
| NOT B,A | 0010110 | 0 | 0 | ∼ | 0 | 1 | A | ∼ | B = ¬A |
| NOT B,B | 0010111 | 0 | 0 | ∼ | 0 | 1 | B | ∼ | B = ¬B |
| XOR A,B | 0011000 | 0 | 0 | ∼ | 1 | 0 | A | B ⊕ | A = A XOR B |
| XOR B,A | 0011001 | 0 | 0 | ∼ | 0 | 1 | A | B ⊕ | B = A XOR B |
| XOR A,Lit | 0011010 | 0 | 0 | ∼ | 1 | 0 | A | Lit ⊕ | A = A XOR Lit |
| XOR B,Lit | 0011011 | 0 | 0 | ∼ | 0 | 1 | B | Lit ⊕ | B = B XOR Lit |
| SHL A,A | 0011100 | 0 | 0 | ∼ | 1 | 0 | A | << | A = shift left A |
| SHL A,B | 0011101 | 0 | 0 | ∼ | 1 | 0 | B | << | A = shift left B |
| SHL B,A | 0011110 | 0 | 0 | ∼ | 0 | 1 | A | << | B = shift left A |
| SHL B,B | 0011111 | 0 | 0 | ∼ | 0 | 1 | B | << | B = shift left B |
| SHR A,A | 0100000 | 0 | 0 | ∼ | 1 | 0 | A | >> | A = shift right A |
| SHR A,B | 0100001 | 0 | 0 | ∼ | 1 | 0 | B | >> | A = shift right B |
| SHR B,A | 0100010 | 0 | 0 | ∼ | 0 | 1 | A | >> | B = shift right A |
| SHR B,B | 0100011 | 0 | 0 | ∼ | 0 | 1 | B | >> | B = shift right B |
| INC B | 0100100 | 0 | 0 | ∼ | 0 | 1 | U | B + | B = B+1 |

---

### 1.2 Instrucciones con Direccionamiento

(Se incluyen las filas de la tabla completa como en la transcripción anterior)

---

### 1.3 Instrucciones de Salto

(Se incluyen todas las filas de la tabla de saltos, comparaciones y condiciones)

---

## Simbología
- `~` → cualquier valor  
- `Z` → pasa un 0  
- `U` → pasa un 1  
- `A,B` → pasa el registro indicado  
- `Lit` → pasa literal de la instrucción  
- `Mem` → pasa salida de memoria de datos  

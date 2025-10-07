# Computador Básico - Instrucciones (cb-instrucciones_arq.pdf)

## Figura 1: Computador básico completo

El documento parte mostrando un **diagrama de un computador básico** con sus bloques principales:

-   **ALU** (Unidad Aritmética y Lógica)
-   **Registros A y B** (almacenan operandos)
-   **Instruction Memory** (memoria de instrucciones) con PC (Program Counter)
-   **Data Memory** (memoria de datos)
-   **Multiplexores (Mux A, Mux B, Mux Data)**
-   **Unidad de Control (Control Unit)**
-   **Status Register** con banderas Z, N, C, V:
    -   **Z** = Zero (resultado 0)
    -   **N** = Negative (resultado negativo)
    -   **C** = Carry (acarreo)
    -   **V** = Overflow (desbordamiento)

---

## 1. Assembly

### 1.1 Instrucciones Básicas

| Inst. | Oper. | opcode  | LPC | DW  | SD0 | LA  | LB  | SA0,1 | SB0,1 | S0,1,2 | Operación         |
| ----- | ----- | ------- | --- | --- | --- | --- | --- | ----- | ----- | ------ | ----------------- |
| MOV   | A,B   | 0000000 | 0   | 0   | ∼   | 1   | 0   | Z     | B     | +      | A = B             |
| MOV   | B,A   | 0000001 | 0   | 0   | ∼   | 0   | 1   | A     | Z     | +      | B = A             |
| MOV   | A,Lit | 0000010 | 0   | 0   | ∼   | 1   | 0   | Z     | Lit   | +      | A = Lit           |
| MOV   | B,Lit | 0000011 | 0   | 0   | ∼   | 0   | 1   | Z     | Lit   | +      | B = Lit           |
| ADD   | A,B   | 0000100 | 0   | 0   | ∼   | 1   | 0   | A     | B     | +      | A = A+B           |
| ADD   | B,A   | 0000101 | 0   | 0   | ∼   | 0   | 1   | A     | B     | +      | B = A+B           |
| ADD   | A,Lit | 0000110 | 0   | 0   | ∼   | 1   | 0   | A     | Lit   | +      | A = A+Lit         |
| ADD   | B,Lit | 0000111 | 0   | 0   | ∼   | 0   | 1   | B     | Lit   | +      | B = B+Lit         |
| SUB   | A,B   | 0001000 | 0   | 0   | ∼   | 1   | 0   | A     | B     | -      | A = A-B           |
| SUB   | B,A   | 0001001 | 0   | 0   | ∼   | 0   | 1   | A     | B     | -      | B = A-B           |
| SUB   | A,Lit | 0001010 | 0   | 0   | ∼   | 1   | 0   | A     | Lit   | -      | A = A-Lit         |
| SUB   | B,Lit | 0001011 | 0   | 0   | ∼   | 0   | 1   | B     | Lit   | -      | B = B-Lit         |
| AND   | A,B   | 0001100 | 0   | 0   | ∼   | 1   | 0   | A     | B     | &      | A = A AND B       |
| AND   | B,A   | 0001101 | 0   | 0   | ∼   | 0   | 1   | A     | B     | &      | B = A AND B       |
| AND   | A,Lit | 0001110 | 0   | 0   | ∼   | 1   | 0   | A     | Lit   | &      | A = A AND Lit     |
| AND   | B,Lit | 0001111 | 0   | 0   | ∼   | 0   | 1   | B     | Lit   | &      | B = B AND Lit     |
| OR    | A,B   | 0010000 | 0   | 0   | ∼   | 1   | 0   | A     | B     | ∥∥      | A = A OR B        |
| OR    | B,A   | 0010001 | 0   | 0   | ∼   | 0   | 1   | A     | B     | ∥∥      | B = A OR B        |
| OR    | A,Lit | 0010010 | 0   | 0   | ∼   | 1   | 0   | A     | Lit   | ∥∥      | A = A OR Lit      |
| OR    | B,Lit | 0010011 | 0   | 0   | ∼   | 0   | 1   | B     | Lit   | ∥∥      | B = B OR Lit      |
| NOT   | A,A   | 0010100 | 0   | 0   | ∼   | 1   | 0   | A     | ∼     | ¬      | A = ¬A            |
| NOT   | A,B   | 0010101 | 0   | 0   | ∼   | 1   | 0   | B     | ∼     | ¬      | A = ¬B            |
| NOT   | B,A   | 0010110 | 0   | 0   | ∼   | 0   | 1   | A     | ∼     | ¬      | B = ¬A            |
| NOT   | B,B   | 0010111 | 0   | 0   | ∼   | 0   | 1   | B     | ∼     | ¬      | B = ¬B            |
| XOR   | A,B   | 0011000 | 0   | 0   | ∼   | 1   | 0   | A     | B     | ⊕      | A = A XOR B       |
| XOR   | B,A   | 0011001 | 0   | 0   | ∼   | 0   | 1   | A     | B     | ⊕      | B = A XOR B       |
| XOR   | A,Lit | 0011010 | 0   | 0   | ∼   | 1   | 0   | A     | Lit   | ⊕      | A = A XOR Lit     |
| XOR   | B,Lit | 0011011 | 0   | 0   | ∼   | 0   | 1   | B     | Lit   | ⊕      | B = B XOR Lit     |
| SHL   | A,A   | 0011100 | 0   | 0   | ∼   | 1   | 0   | A     | ∼     | <<     | A = shift left A  |
| SHL   | A,B   | 0011101 | 0   | 0   | ∼   | 1   | 0   | B     | ∼     | <<     | A = shift left B  |
| SHL   | B,A   | 0011110 | 0   | 0   | ∼   | 0   | 1   | A     | ∼     | <<     | B = shift left A  |
| SHL   | B,B   | 0011111 | 0   | 0   | ∼   | 0   | 1   | B     | ∼     | <<     | B = shift left B  |
| SHR   | A,A   | 0100000 | 0   | 0   | ∼   | 1   | 0   | A     | ∼     | >>     | A = shift right A |
| SHR   | A,B   | 0100001 | 0   | 0   | ∼   | 1   | 0   | B     | ∼     | >>     | A = shift right B |
| SHR   | B,A   | 0100010 | 0   | 0   | ∼   | 0   | 1   | A     | ∼     | >>     | B = shift right A |
| SHR   | B,B   | 0100011 | 0   | 0   | ∼   | 0   | 1   | B     | ∼     | >>     | B = shift right B |
| INC   | B     | 0100100 | 0   | 0   | ∼   | 0   | 1   | U     | B     | +      | B = B+1           |

---

### 1.2 Instrucciones con Direccionamiento

| Inst. | Oper.   | Opcode  | LPC | DW  | SD0 | LA  | LB  | SA  | SB  | S   | Operación                |
| :---- | :------ | :------ | :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- | :----------------------- |
| MOV   | A,(Dir) | 0100101 | 0   | 0   | Lit | 1   | 0   | Z   | Mem | +   | A = Mem[Lit]             |
| MOV   | B,(Dir) | 0100110 | 0   | 0   | Lit | 0   | 1   | Z   | Mem | +   | B = Mem[Lit]             |
| MOV   | (Dir),A | 0100111 | 0   | 1   | Lit | 0   | 0   | A   | Z   | +   | Mem[Lit] = A             |
| MOV   | (Dir),B | 0101000 | 0   | 1   | Lit | 0   | 0   | Z   | B   | +   | Mem[Lit] = B             |
| MOV   | A,(B)   | 0101001 | 0   | 0   | B   | 1   | 0   | Z   | Mem | +   | A = Mem[B]               |
| MOV   | B,(B)   | 0101010 | 0   | 0   | B   | 0   | 1   | Z   | Mem | +   | B = Mem[B]               |
| MOV   | (B),A   | 0101011 | 0   | 1   | B   | 0   | 0   | A   | Z   | +   | Mem[B] = A               |
| ADD   | A,(Dir) | 0101100 | 0   | 0   | Lit | 1   | 0   | A   | Mem | +   | A = A + Mem[Lit]         |
| ADD   | B,(Dir) | 0101101 | 0   | 0   | Lit | 0   | 1   | B   | Mem | +   | B = B + Mem[Lit]         |
| ADD   | A,(B)   | 0101110 | 0   | 0   | B   | 1   | 0   | A   | Mem | +   | A = A + Mem[B]           |
| ADD   | (Dir)   | 0101111 | 0   | 1   | Lit | 0   | 0   | A   | B   | +   | Mem[Lit] = A + B         |
| SUB   | A,(Dir) | 0110000 | 0   | 0   | Lit | 1   | 0   | A   | Mem | −   | A = A − Mem[Lit]         |
| SUB   | B,(Dir) | 0110001 | 0   | 0   | Lit | 0   | 1   | B   | Mem | −   | B = B − Mem[Lit]         |
| SUB   | A,(B)   | 0110010 | 0   | 0   | B   | 1   | 0   | A   | Mem | −   | A = A − Mem[B]           |
| SUB   | (Dir)   | 0110011 | 0   | 1   | Lit | 0   | 0   | A   | B   | −   | Mem[Lit] = A − B         |
| AND   | A,(Dir) | 0110100 | 0   | 0   | Lit | 1   | 0   | A   | Mem | &   | A = A and Mem[Lit]       |
| AND   | B,(Dir) | 0110101 | 0   | 0   | Lit | 0   | 1   | B   | Mem | &   | B = B and Mem[Lit]       |
| AND   | A,(B)   | 0110110 | 0   | 0   | B   | 1   | 0   | A   | Mem | &   | A = A and Mem[B]         |
| AND   | (Dir)   | 0110111 | 0   | 1   | Lit | 0   | 0   | A   | B   | &   | Mem[Lit] = A and B       |
| OR    | A,(Dir) | 0111000 | 0   | 0   | Lit | 1   | 0   | A   | Mem | ∥∥   | A = A or Mem[Lit]        |
| OR    | B,(Dir) | 0111001 | 0   | 0   | Lit | 0   | 1   | B   | Mem | ∥∥   | B = B or Mem[Lit]        |
| OR    | A,(B)   | 0111010 | 0   | 0   | B   | 1   | 0   | A   | Mem | ∥∥   | A = A or Mem[B]          |
| OR    | (Dir)   | 0111011 | 0   | 1   | Lit | 0   | 0   | A   | B   | ∥∥   | Mem[Lit] = A or B        |
| NOT   | (Dir),A | 0111100 | 0   | 1   | Lit | 0   | 0   | A   | ∼   | ¬   | Mem[Lit] = ¬A            |
| NOT   | (Dir),B | 0111101 | 0   | 1   | Lit | 0   | 0   | B   | ∼   | ¬   | Mem[Lit] = ¬B            |
| NOT   | (B)     | 0111110 | 0   | 1   | B   | 0   | 0   | A   | ∼   | ¬   | Mem[B] = ¬A              |
| XOR   | A,(Dir) | 0111111 | 0   | 0   | Lit | 1   | 0   | A   | Mem | ⊕   | A = A xor Mem[Dir]       |
| XOR   | B,(Dir) | 1000000 | 0   | 0   | Lit | 0   | 1   | B   | Mem | ⊕   | B = B xor Mem[Lit]       |
| XOR   | A,(B)   | 1000001 | 0   | 0   | B   | 1   | 0   | A   | Mem | ⊕   | A = A xor Mem[B]         |
| XOR   | (Dir)   | 1000010 | 0   | 1   | Lit | 0   | 0   | A   | B   | ⊕   | Mem[Lit] = A xor B       |
| SHL   | (Dir),A | 1000011 | 0   | 1   | Lit | 0   | 0   | A   | ∼   | <<  | Mem[Lit] = shift left A  |
| SHL   | (Dir),B | 1000100 | 0   | 1   | Lit | 0   | 0   | B   | ∼   | <<  | Mem[Lit] = shift left B  |
| SHL   | (B)     | 1000101 | 0   | 1   | B   | 0   | 0   | A   | ∼   | <<  | Mem[B] = shift left A    |
| SHR   | (Dir),A | 1000110 | 0   | 1   | Lit | 0   | 0   | A   | ∼   | >>  | Mem[Lit] = shift right A |
| SHR   | (Dir),B | 1000111 | 0   | 1   | Lit | 0   | 0   | B   | ∼   | >>  | Mem[Lit] = shift right B |
| SHR   | (B)     | 1001000 | 0   | 1   | B   | 0   | 0   | A   | ∼   | >>  | Mem[B] = shift right A   |
| INC   | (Dir)   | 1001001 | 0   | 1   | Lit | 0   | 0   | U   | Mem | +   | Mem[Lit] = Mem[Lit] + 1  |
| INC   | (B)     | 1001010 | 0   | 1   | B   | 0   | 0   | U   | Mem | +   | Mem[B] = Mem[B] + 1      |
| RST   | (Dir)   | 1001011 | 0   | 1   | Lit | 0   | 0   | Z   | Z   | +   | Mem[Lit] = 0             |
| RST   | (B)     | 1001100 | 0   | 1   | B   | 0   | 0   | Z   | Z   | +   | Mem[B] = 0               |

---

### 1.3 Instrucciones de Salto

| Inst. | Oper.   | Opcode  | LPC | DW | SD0 | LA | LB | SA | SB  | S  | Operación            |
| :---- | :------ | :------ | :-- | :- | :-- | :- | :- | :- | :-- | :- | :------------------- |
| CMP   | A,B     | 1001101 | 0   | 0  | ∼   | 0  | 0  | A  | B   | −  | A − B                |
| CMP   | A,Lit   | 1001110 | 0   | 0  | ∼   | 0  | 0  | A  | Lit | −  | A − Lit              |
| CMP   | B,Lit   | 1001111 | 0   | 0  | ∼   | 0  | 0  | B  | Lit | −  | B − Lit              |
| CMP   | A,(Dir) | 1010000 | 0   | 0  | Lit | 0  | 0  | A  | Mem | −  | A − Mem[Lit]         |
| CMP   | B,(Dir) | 1010001 | 0   | 0  | Lit | 0  | 0  | B  | Mem | −  | B − Mem[Lit]         |
| CMP   | A,(B)   | 1010010 | 0   | 0  | B   | 0  | 0  | A  | Mem | −  | A − Mem[B]           |
| JMP   | Dir     | 1010011 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit             |
| JEQ   | Dir     | 1010100 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (Z = 1)     |
| JNE   | Dir     | 1010101 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (Z = 0)     |
| JGT   | Dir     | 1010110 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (N=0 ∧ Z=0) |
| JLT   | Dir     | 1010111 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (N=1)       |
| JGE   | Dir     | 1011000 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (N=0)       |
| JLE   | Dir     | 1011001 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (N=1 ∨ Z=1) |
| JCR   | Dir     | 1011010 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (C=1)       |
| JOV   | Dir     | 1011011 | 1   | 0  | ∼   | 0  | 0  | ∼  | ∼   | ∼  | PC = Lit (V=1)       |


---

## Simbología

-   `~` → cualquier valor
-   `Z` → pasa un 0
-   `U` → pasa un 1
-   `A,B` → pasa el registro indicado
-   `Lit` → pasa literal de la instrucción
-   `Mem` → pasa salida de memoria de datos

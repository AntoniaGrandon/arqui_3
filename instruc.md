# 📋 INSTRUCCIONES PARA IMPLEMENTAR muxA Y COMPLETAR EL SISTEMA

## 🎯 Objetivo
Necesito agregar un multiplexor adicional (`muxA`) al diseño del computador básico y completar la unidad de control con todas las instrucciones faltantes para que el testbench funcione correctamente.

## 📁 Contexto del Proyecto
Tengo un computador básico en Verilog con los siguientes módulos ya implementados:
- `alu.v` - ALU con 10 operaciones (ADD, SUB, AND, OR, NOT, XOR, SHL, SHR, INC, MOV)
- `register.v` - Registros A y B de 8 bits
- `pc.v` - Program Counter de 4 bits
- `instruction_memory.v` - Memoria de 16 instrucciones de 15 bits
- `muxB.v` - Multiplexor que selecciona entre regB y literal
- `control_unit.v` - Unidad de control (solo 6 instrucciones implementadas)
- `computer.v` - Módulo top que conecta todo

## 🚨 Problema Actual
La entrada `a` de la ALU está **fija** al registro A:
```verilog
alu ALU(.a(regA_out_bus), .b(muxB_out_bus), .s(alu_op), .out(alu_out_bus));
```

Esto impide que funcionen correctamente instrucciones como:
- `NOT A, B` - necesita hacer `~B` pero la ALU hace `~A`
- `SHL A, B` - necesita hacer `B << 1` pero la ALU hace `A << 1`
- `INC B` - necesita hacer `B + 1` pero la ALU opera sobre A

## ✅ Solución Propuesta
Agregar un multiplexor `muxA` que seleccione entre regA o regB para la entrada `a` de la ALU.

---

## 📝 TAREA 1: Crear el archivo `muxA.v`

Por favor crea un nuevo archivo llamado `muxA.v` con el siguiente código:

```verilog
module muxA(
    input [7:0] regA,      
    input [7:0] regB,      
    input sel,             
    output reg [7:0] out   
);
    always @(*) begin      
        case(sel)
            1'b0: out = regA;  
            1'b1: out = regB;  
        endcase
    end
endmodule
```

**Explicación:**
- Si `sel = 0`: pasa regA (comportamiento normal)
- Si `sel = 1`: pasa regB (para instrucciones especiales)

---

## 📝 TAREA 2: Modificar `computer.v`

Necesito que modifiques el archivo `computer.v` para integrar el nuevo `muxA`.

### Cambios necesarios:

#### 1. Agregar nueva señal de control y bus

Después de la línea:
```verilog
wire muxB_sel, regA_load, regB_load;
```

Agregar:
```verilog
wire muxA_sel;
```

Y después de:
```verilog
wire [7:0] muxB_out_bus;
```

Agregar:
```verilog
wire [7:0] muxA_out_bus;
```

#### 2. Actualizar la instancia de control_unit

Cambiar:
```verilog
control_unit CU(
    .opcode(opcode),
    .alu_op(alu_op),
    .muxB_sel(muxB_sel),
    .regA_load(regA_load),
    .regB_load(regB_load)
);
```

Por:
```verilog
control_unit CU(
    .opcode(opcode),
    .alu_op(alu_op),
    .muxA_sel(muxA_sel),
    .muxB_sel(muxB_sel),
    .regA_load(regA_load),
    .regB_load(regB_load)
);
```

#### 3. Instanciar el módulo muxA

Antes de la línea que instancia la ALU, agregar:
```verilog
muxA muxA_inst(.regA(regA_out_bus), .regB(regB_out_bus), .sel(muxA_sel), .out(muxA_out_bus));
```

#### 4. Modificar la conexión de la ALU

Cambiar:
```verilog
alu ALU(.a(regA_out_bus), .b(muxB_out_bus), .s(alu_op), .out(alu_out_bus));
```

Por:
```verilog
alu ALU(.a(muxA_out_bus), .b(muxB_out_bus), .s(alu_op), .out(alu_out_bus));
```

---

## 📝 TAREA 3: Completar `control_unit.v`

Necesito que modifiques `control_unit.v` para:

### 1. Agregar la salida `muxA_sel`

Cambiar:
```verilog
module control_unit(
    input [6:0] opcode,
    output reg [3:0] alu_op,
    output reg muxB_sel,
    output reg regA_load,
    output reg regB_load
);
```

Por:
```verilog
module control_unit(
    input [6:0] opcode,
    output reg [3:0] alu_op,
    output reg muxA_sel,
    output reg muxB_sel,
    output reg regA_load,
    output reg regB_load
);
```

### 2. Actualizar el bloque default

Cambiar:
```verilog
default: begin
    alu_op    = 4'b0000;
    muxB_sel  = 0;
    regA_load = 0;
    regB_load = 0;
end
```

Por:
```verilog
default: begin
    alu_op    = 4'b0000;
    muxA_sel  = 0;
    muxB_sel  = 0;
    regA_load = 0;
    regB_load = 0;
end
```

### 3. Actualizar todos los casos existentes

Agregar `muxA_sel = 0;` a todos los casos que ya existen (MOV A,Lit, MOV B,Lit, etc.)

### 4. Completar el `case` con todas las instrucciones faltantes

---

## 📊 TABLA DE REFERENCIA: Todas las instrucciones a implementar

Aquí está la tabla completa con los valores que debe generar la Control Unit para cada opcode:

### Grupo MOV (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0000000` | MOV A, B | `1001` | 0 | 0 | 1 | 0 |
| `0000001` | MOV B, A | `1001` | 0 | 0 | 0 | 1 |
| `0000010` | MOV A, Lit | `1001` | 0 | 1 | 1 | 0 |
| `0000011` | MOV B, Lit | `1001` | 0 | 1 | 0 | 1 |

### Grupo ADD (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0000100` | ADD A, B | `0000` | 0 | 0 | 1 | 0 |
| `0000101` | ADD B, A | `0000` | 0 | 0 | 0 | 1 |
| `0000110` | ADD A, Lit | `0000` | 0 | 1 | 1 | 0 |
| `0000111` | ADD B, Lit | `0000` | 1 | 1 | 0 | 1 |

### Grupo SUB (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0001000` | SUB A, B | `0001` | 0 | 0 | 1 | 0 |
| `0001001` | SUB B, A | `0001` | 0 | 0 | 0 | 1 |
| `0001010` | SUB A, Lit | `0001` | 0 | 1 | 1 | 0 |
| `0001011` | SUB B, Lit | `0001` | 1 | 1 | 0 | 1 |

### Grupo AND (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0001100` | AND A, B | `0010` | 0 | 0 | 1 | 0 |
| `0001101` | AND B, A | `0010` | 0 | 0 | 0 | 1 |
| `0001110` | AND A, Lit | `0010` | 0 | 1 | 1 | 0 |
| `0001111` | AND B, Lit | `0010` | 1 | 1 | 0 | 1 |

### Grupo OR (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0010000` | OR A, B | `0011` | 0 | 0 | 1 | 0 |
| `0010001` | OR B, A | `0011` | 0 | 0 | 0 | 1 |
| `0010010` | OR A, Lit | `0011` | 0 | 1 | 1 | 0 |
| `0010011` | OR B, Lit | `0011` | 1 | 1 | 0 | 1 |

### Grupo NOT (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0010100` | NOT A, A | `0100` | 0 | 0 | 1 | 0 |
| `0010101` | NOT A, B | `0100` | 1 | 0 | 1 | 0 |
| `0010110` | NOT B, A | `0100` | 0 | 0 | 0 | 1 |
| `0010111` | NOT B, B | `0100` | 1 | 0 | 0 | 1 |

### Grupo XOR (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0011000` | XOR A, B | `0101` | 0 | 0 | 1 | 0 |
| `0011001` | XOR B, A | `0101` | 0 | 0 | 0 | 1 |
| `0011010` | XOR A, Lit | `0101` | 0 | 1 | 1 | 0 |
| `0011011` | XOR B, Lit | `0101` | 1 | 1 | 0 | 1 |

### Grupo SHL (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0011100` | SHL A, A | `0110` | 0 | 0 | 1 | 0 |
| `0011101` | SHL A, B | `0110` | 1 | 0 | 1 | 0 |
| `0011110` | SHL B, A | `0110` | 0 | 0 | 0 | 1 |
| `0011111` | SHL B, B | `0110` | 1 | 0 | 0 | 1 |

### Grupo SHR (4 instrucciones)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0100000` | SHR A, A | `0111` | 0 | 0 | 1 | 0 |
| `0100001` | SHR A, B | `0111` | 1 | 0 | 1 | 0 |
| `0100010` | SHR B, A | `0111` | 0 | 0 | 0 | 1 |
| `0100011` | SHR B, B | `0111` | 1 | 0 | 0 | 1 |

### INC (1 instrucción)
| Opcode | Instrucción | alu_op | muxA_sel | muxB_sel | regA_load | regB_load |
|--------|-------------|--------|----------|----------|-----------|-----------|
| `0100100` | INC B | `1000` | 1 | 0 | 0 | 1 |

---

## 🔍 REGLA IMPORTANTE para muxA_sel:

- **`muxA_sel = 0`**: Cuando la operación usa el **primer operando** mencionado en la instrucción
  - Ejemplo: `ADD A, B` → opera sobre A, entonces muxA_sel = 0
  - Ejemplo: `NOT A, A` → opera sobre A, entonces muxA_sel = 0

- **`muxA_sel = 1`**: Cuando la operación debe usar el **segundo operando** 
  - Ejemplo: `ADD B, Lit` → necesita B en entrada `a` de ALU, entonces muxA_sel = 1
  - Ejemplo: `NOT A, B` → necesita B en entrada `a` para hacer ~B, entonces muxA_sel = 1
  - Ejemplo: `INC B` → necesita B en entrada `a` para hacer B+1, entonces muxA_sel = 1

---

## 📝 TAREA 4: Actualizar Makefile

Agregar `muxA.v` a la lista de archivos en el Makefile:

Cambiar:
```makefile
VERILOG_FILES = computer.v alu.v instruction_memory.v mux2.v pc.v register.v control_unit.v muxB.v
```

Por:
```makefile
VERILOG_FILES = computer.v alu.v instruction_memory.v mux2.v muxA.v muxB.v pc.v register.v control_unit.v
```

---

## ✅ Resultado Esperado

Después de estos cambios:
1. ✅ El archivo `muxA.v` debe existir
2. ✅ `computer.v` debe tener muxA instanciado y conectado
3. ✅ `control_unit.v` debe tener `muxA_sel` como salida
4. ✅ `control_unit.v` debe tener todos los 37 casos implementados
5. ✅ El Makefile debe incluir `muxA.v`
6. ✅ Al compilar y ejecutar el testbench, todos los tests deben pasar

---

## 🎯 Prioridad de Implementación

**IMPORTANTE**: Implementa los casos en `control_unit.v` en este orden (por grupos de tests del testbench):
1. MOV (4 casos) - Test 0 y 1
2. ADD (4 casos) - Test 2
3. SUB (4 casos) - Test 3
4. AND (4 casos) - Test 4
5. OR (4 casos) - Test 5
6. NOT (4 casos) - Test 6
7. XOR (4 casos) - Test 7
8. SHL (4 casos) - Test 8
9. SHR (4 casos) - Test 9
10. INC (1 caso) - Test 10

---

## 🧪 Verificación

Para verificar que todo funciona:

```bash
# Compilar
make build

# Ejecutar simulación
make run

# Ver formas de onda (opcional)
make wave
```

El testbench debe mostrar:
```
>>>>> MOV TEST PASSED! <<<<<
>>>>> REGISTER MOV TEST PASSED! <<<<<
>>>>> ALL ADD TESTS PASSED! <<<<<
>>>>> ALL SUB TESTS PASSED! <<<<<
>>>>> ALL AND TESTS PASSED! <<<<<
>>>>> ALL OR TESTS PASSED! <<<<<
>>>>> ALL NOT TESTS PASSED! <<<<<
>>>>> ALL XOR TESTS PASSED! <<<<<
>>>>> ALL SHL TESTS PASSED! <<<<<
>>>>> ALL SHR TESTS PASSED! <<<<<
>>>>> ALL INC TESTS PASSED! <<<<<
```

---

## 📚 Documentación Adicional

Para más detalles sobre el funcionamiento del sistema, consultar:
- `FLUJO_COMPLETO.md` - Flujo detallado del programa con todos los ejemplos
- `instruction.md` - Especificación completa de instrucciones
- `README.md` - Información general del proyecto

---

**Fecha de creación:** Octubre 2025  
**Proyecto:** Arquitectura de Computadores - Práctica 2 - Grupo 7  
**Versión:** 1.0

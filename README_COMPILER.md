Proyecto 4 — Compilador (parcial)

Resumen
-------
Este repositorio ahora incluye un compilador mínimo (archivo `tools_compiler.py`) que toma un bloque `DATA:` y una asignación `result = <expresión>` y genera un conjunto de instrucciones ASUA-like.

Soporte actual (parcial):
- Operadores: +, -
- Paréntesis
- Variables: nombres alfanuméricos (ej. a, b, c, result, error)
- Cuenta líneas generadas y accesos a memoria (cada `LD var` y el `ST result, A` cuentan como 1 acceso)

Formato de entrada
------------------
El input es un archivo de texto con un bloque DATA y una línea con `result = ...`.
Ejemplo:

DATA:
a 1
b 3
c 45
d 2
e 4
f 5
g 6
error 0
result 0

result = a + b + c + (d + e)

Uso
---
```powershell
python tools_compiler.py input.txt
```
Salida
-----
El programa imprimirá la secuencia de instrucciones (mnemonics ASUA-like), y una línea final con conteo de líneas y accesos a memoria.

Siguientes pasos sugeridos
-------------------------
- Añadir soporte para *, /, % y funciones (max,min,abs).
- Generar una traducción a los binarios de 15 bits del ISA del proyecto (si se desea programar la FPGA después).
- Mejorar la optimización para reducir accesos a memoria (caching, orden de evaluación).

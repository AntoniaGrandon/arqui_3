# Proyecto 3 — Fabricación y Emulación del Chip

Este documento resume el enunciado en `Proyecto_3 (1).pdf`/`Proyecto_3.txt`: objetivos, entregas, requisitos y un checklist accionable con hitos.

## Resumen en 10 puntos

1. Objetivo: Llevar tu core de 8 bits (RTL en Verilog) por el flujo completo de OpenLane hasta un archivo fabricable (.GDS) y luego emularlo en una FPGA.
2. Herramientas: Para GDS, usar la máquina virtual del curso Zero to ASIC (VM grande, requiere VirtualBox). Para FPGA, usar APIO (instalar fuera de la VM).
3. FPGA: Se usará la Go Board de Nandland; APIO funciona como wrapper de herramientas y debe configurarse con la documentación de Nandland.
4. Emulación vs simulación: La actividad en FPGA es emulación del chip (no simulación), ejecutando software sobre tu core.
5. Recursos limitados: Hay 11 FPGAs para 18 grupos; se asignan ventanas de uso específicas. Antes de pedir una FPGA, debes demostrar un `apio build` exitoso de tu proyecto.
6. Entrega Parcial (22 de octubre):
   - OpenLane: elegir un ejemplo de la VM (distinto a `spm`), correr el flujo, y poder extraer/mostrar métricas pedidas (p.ej., área, cantidad de compuertas, GDS, mapas de densidad de potencia/compuertas).
   - APIO/FPGA: flashear un diseño donde cada botón mapea a un LED (apretar botón enciende el LED correspondiente).
7. Entrega Final (29 de octubre):
   - OpenLane: correr tu computador (core de 8 bits) por el flujo y poder mostrar métricas/artefactos cuando se solicite.
   - APIO/FPGA: flashear tu computador y ejecutar un programa que cuente de 15 a 0, mostrando el valor en decimal en el display y en binario en los cuatro LEDs. Esta funcionalidad debe salir del software corriendo en tu core (no cableada directamente en Verilog).
8. Demostrables típicos de OpenLane: logs/reportes, `gds`, métricas de síntesis/colocación/ruteo, mapas de densidad.
9. Recomendación operativa: Optimiza tiempos de laboratorio; prepara y valida `apio build` antes de tomar una FPGA.
10. Material de apoyo: Documentación de OpenLane/OpenROAD, ejemplos de OpenLane, introducción a FPGAs y proyectos de ejemplo.

## Requisitos y criterios (implícitos del enunciado)

- Herramientas instaladas y funcionales: VM de Zero to ASIC (OpenLane) y APIO configurado para Go Board.
- OpenLane ejemplo (Parcial):
  - Debe ser un ejemplo distinto a `spm` de la VM.
  - Se espera poder obtener y explicar métricas: área, gate count, `gds`, mapas de densidad (potencia/compuertas) u otros que pida el ayudante.
- APIO ejemplo (Parcial):
  - Top sencillo botón→LED, flasheado y funcionando en la Go Board.
- OpenLane core propio (Final):
  - Core de 8 bits pasa por todo el flujo (synth → PnR → GDS) sin errores bloqueantes.
  - Saber dónde y cómo extraer métricas/artefactos para mostrarlas bajo pedido.
- APIO core propio (Final):
  - Top de FPGA integra tu core con los periféricos (display + 4 LEDs) y reloj/reset.
  - Programa de usuario (no lógica cableada) que cuente 15→0 y muestre: decimal en display y binario en 4 LEDs.
- Gestión de recursos: `apio build` exitoso antes de uso de FPGA; uso de ventanas de laboratorio.

## Checklist accionable con hitos

Hito 0 — Base de herramientas (hoy)
- [ ] Descargar e importar la VM de Zero to ASIC; abrir OpenLane en la VM.
- [ ] Instalar APIO local y configurar la Go Board (seguir doc de Nandland); verificar `apio --version`.
- [ ] Repositorio listo: estructura para RTL del core, toplevel de FPGA y scripts (build/run/report).

Hito 1 — Entrega Parcial (22 oct)
OpenLane (ejemplo no `spm`):
- [ ] Elegir ejemplo y correr el flujo completo en OpenLane.
- [ ] Ubicar y guardar artefactos: `gds`, reportes de síntesis (área, gates), PnR y mapas de densidad.
- [ ] Preparar mini-guía: “cómo obtuve cada métrica” (rutas a logs/reportes, screenshots).
APIO/FPGA (botón→LED):
- [ ] Crear toplevel Verilog para Go Board con mapeo botón→LED.
- [ ] `apio build` sin errores; flashear y probar físicamente en la placa.
- [ ] Evidencia: breve video/foto y commit con fuentes + config APIO.

Hito 2 — OpenLane de tu core (24–26 oct)
- [ ] Adaptar RTL del core para síntesis (clocks, resets, no primitivas no soportadas, constraints básicos).
- [ ] Correr flujo OpenLane sobre el core; iterar hasta cerrar DRC/LVS y generar `gds`.
- [ ] Recopilar métricas y capturas (área, gates, congestión, densidad, tiempos si aplica).

Hito 3 — Integración FPGA y programa (26–28 oct)
- [ ] Toplevel FPGA que integra core + memoria de programa + IO (display + 4 LEDs) + reloj/reset.
- [ ] Generar binario/hex del programa “15→0” para la memoria del core.
- [ ] `apio build` y flasheo; depurar hasta ver conteo correcto en display y LEDs.
- [ ] Verificación: demostrar que el conteo proviene del software (cambiar velocidad, añadir beep/LED parpadeo condicional, etc.).

Hito 4 — Entrega Final (29 oct)
- [ ] Demostración en OpenLane: métricas y artefactos del core listos para mostrar.
- [ ] Demostración en FPGA: conteo 15→0 en display (decimal) y 4 LEDs (binario), ejecutado por el core.
- [ ] Entregables ordenados: fuentes, scripts, `README` con pasos y evidencias (screenshots, fotos/video).

## Riesgos y mitigaciones

- Herramientas/entorno: tiempos de descarga de la VM, dependencias, configuraciones APIO/board. Mitigar probando ASAP y documentando comandos.
- Síntesis/PNR del core: incompatibilidades RTL, timing, DRC/LVS. Mitigar con versiones mínimas del core, dividir en módulos, constraints simples.
- Integración de IO (display): protocolos/timing del display de la Go Board. Mitigar usando ejemplos de Nandland y testbench en sim para el driver.
- Acceso a FPGA: cupos y ventanas limitadas. Mitigar con `apio build` listo antes y lista de pruebas rápida.
- Función por software (no cableada): asegurar ROM/loader del programa y ruta de datos/IO funcionando.

## Evidencias recomendadas

- OpenLane: `gds`, `reports/` de synth/PnR, capturas de mapas de densidad; nota de dónde extraer métricas.
- FPGA: `apio build` logs, bitstream/flasheo exitoso, fotos/video mostrando botón→LED (parcial) y conteo 15→0 (final).
- Documentación breve en el repo con pasos reproducibles.

---
Este resumen está basado en el contenido de `Proyecto_3.txt`. Ajusta fechas/ventanas si la coordinación del curso publica cambios.

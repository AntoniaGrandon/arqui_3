Delivery instructions — Final project (Go-board)

Overview
--------
This repository contains a small educational CPU implemented in Verilog and a minimal FPGA top (`top_final.v`) that maps the CPU outputs to 4 LEDs on the Go-board.

Files relevant for FPGA delivery
- `top_final.v` — FPGA top that instantiates `computer.v` and maps `regA[3:0]` to LEDs.
- `main_final.pcf` — pin assignments for the Go-board (matches the partial delivery pinout).
- `project.conf` — apio/project configuration (top-module and source list).
- `im.dat` — instruction memory contents. Currently contains a tested countdown program (15→0).

Prerequisites (on your machine)
- apio (recommended), yosys, nextpnr-ice40, iceprog/ecpprog installed and in PATH.
- Python 3.x (for apio environment)

Quick build & program (using apio)
1. Build the project (synthesize + place & route):

```bash
apio build
```

2. Program the board (example with iceprog):

```bash
# replace build/top_final.bin with actual output file from apio
iceprog build/top_final.bin
```

If your board uses ecpprog or other programmer use the appropriate tool.

Makefile targets
- `make build` — compile the Verilog simulation executable (iverilog)
- `make run` — run simulation (vvp)
- `make fpga-build` — (if apio installed) builds the bitstream (not added here to avoid env assumptions)
- `make fpga-program` — (example) program the board with iceprog

Simulation
- Use `make build` and `make run` to run the testbench in `testbench.v`.
- A small testbench `tb_count.v` is included to simulate the countdown program and print `regA` per cycle.

Notes & recommendations
- `im.dat` is intentionally short (not 256 instructions); `$readmemb` warns but simulation works. If you want to avoid the warning, pad `im.dat` to 256 lines.
- If you want UART or button control, we can extend `top_final.v` to expose serial TX/RX and buttons.

Contact
- If you want, I can add `make fpga-build` and `make fpga-program` targets that call `apio build` and `iceprog` respectively. I can also append a short troubleshooting section.

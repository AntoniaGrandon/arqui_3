#EJERCICIO: Rellenar los archivos verilog
yosys read_verilog computer.v alu.v instruction_memory.v mux2.v pc.v register.v testbench.v

yosys synth
yosys write_verilog out/netlist.v

yosys stat
yosys tee -q -o "out/computer.rpt" stat

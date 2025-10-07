module computer(
    input clk,
    output [7:0] alu_out_bus,
    output [7:0] regA_out_bus,
    output [7:0] regB_out_bus
);
    wire [7:0] pc_out_bus;  // Cambiado a 8 bits
    wire [14:0] im_out_bus; // 15 bits por instrucción
    wire [6:0] opcode = im_out_bus[14:8];   // opcode de 7 bits
    wire [7:0] literal = im_out_bus[7:0];   // literal de 8 bits

    wire [3:0] alu_op;
    wire muxA_sel, muxB_sel, regA_load, regB_load;
    wire [7:0] muxA_out_bus;
    wire [7:0] muxB_out_bus;

    pc PC(.clk(clk), .pc(pc_out_bus));
    instruction_memory IM(.address(pc_out_bus), .out(im_out_bus));

    control_unit CU(
        .opcode(opcode),
        .alu_op(alu_op),
        .muxA_sel(muxA_sel),
        .muxB_sel(muxB_sel),
        .regA_load(regA_load),
        .regB_load(regB_load)
    );

    register regA(.clk(clk), .data(alu_out_bus), .load(regA_load), .out(regA_out_bus));
    register regB(.clk(clk), .data(alu_out_bus), .load(regB_load), .out(regB_out_bus));

    muxA muxA_inst(.regA(regA_out_bus), .regB(regB_out_bus), .sel(muxA_sel), .out(muxA_out_bus));
    muxB muxB_inst(.regB(regB_out_bus), .literal(literal), .sel(muxB_sel), .out(muxB_out_bus));

    alu ALU(.a(muxA_out_bus), .b(muxB_out_bus), .s(alu_op), .out(alu_out_bus));
endmodule
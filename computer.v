module computer(
    input clk,
    output [7:0] alu_out_bus,
    output [7:0] regA_out_bus,
    output [7:0] regB_out_bus
);
    wire [7:0] pc_out_bus;
    wire [14:0] im_out_bus;
    wire [6:0] opcode = im_out_bus[14:8];
    wire [7:0] literal = im_out_bus[7:0];

    wire [3:0] alu_op;
    wire muxA_sel, regA_load, regB_load, mem_write, addr_sel;
    wire flags_write;
    wire is_jump;
    wire [3:0] jump_cond;
    wire [7:0] muxA_out_bus;
    wire [7:0] muxB_out_bus;
    wire [1:0] muxB_sel;
    wire [7:0] mem_address;
    wire [7:0] mem_data_out;

    pc PC(
        .clk(clk),
        .pc(pc_out_bus)
    );

    instruction_memory IM(
        .address(pc_out_bus),
        .out(im_out_bus)
    );

    control_unit CU(
        .opcode(opcode),
        .alu_op(alu_op),
        .muxA_sel(muxA_sel),
        .muxB_sel(muxB_sel),
        .regA_load(regA_load),
        .regB_load(regB_load),
        .mem_write(mem_write),
        .addr_sel(addr_sel),
        .flags_write(flags_write),
        .is_jump(is_jump),
        .jump_cond(jump_cond)
    );

    register regA(
        .clk(clk),
        .data(alu_out_bus),
        .load(regA_load),
        .out(regA_out_bus)
    );

    register regB(
        .clk(clk),
        .data(alu_out_bus),
        .load(regB_load),
        .out(regB_out_bus)
    );

    muxA muxA_inst(
        .regA(regA_out_bus),
        .regB(regB_out_bus),
        .sel(muxA_sel),
        .out(muxA_out_bus)
    );

    muxB muxB_inst(
        .regB(regB_out_bus),
        .literal(literal),
        .mem_data(mem_data_out),
        .sel(muxB_sel),
        .out(muxB_out_bus)
    );

    mux_address addr_mux(
        .literal(literal),
        .regB(regB_out_bus),
        .sel(addr_sel),
        .address(mem_address)
    );

    data_memory DM(
        .clk(clk),
        .address(mem_address),
        .data_in(muxA_out_bus),
        .write_enable(mem_write),
        .data_out(mem_data_out)
    );

    alu ALU(
        .a(muxA_out_bus),
        .b(muxB_out_bus),
        .s(alu_op),
        .out(alu_out_bus)
    );

endmodule

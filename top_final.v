module top_final(
    input i_Clk,

    // Board switches (left as available inputs for future use)
    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    // LEDs to observe CPU state
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4
);

    // Instantiate the CPU (computer.v)
    wire [7:0] alu_out_bus;
    wire [7:0] regA_out_bus;
    wire [7:0] regB_out_bus;

    computer CPU (
        .clk(i_Clk),
        .alu_out_bus(alu_out_bus),
        .regA_out_bus(regA_out_bus),
        .regB_out_bus(regB_out_bus)
    );

    // Map lower 4 bits of regA to LEDs for quick observation
    assign o_LED_1 = regA_out_bus[0];
    assign o_LED_2 = regA_out_bus[1];
    assign o_LED_3 = regA_out_bus[2];
    assign o_LED_4 = regA_out_bus[3];

endmodule

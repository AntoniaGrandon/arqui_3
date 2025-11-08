module top(
    input i_Clk,

    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,

    output S1_A,
    output S1_B,
    output S1_C,
    output S1_D,
    output S1_E,
    output S1_F,
    output S1_G,
    output S2_A,
    output S2_B,
    output S2_C,
    output S2_D,
    output S2_E,
    output S2_F,
    output S2_G
);

    wire [7:0] alu_out_bus;
    wire [7:0] regA_out_bus;
    wire [7:0] regB_out_bus;
    wire [7:0] pc_out_bus;

    reg [23:0] clk_div = 0;
    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[21];

    computer CPU (
        .clk(slow_clk),
        .alu_out_bus(alu_out_bus),
        .regA_out_bus(regA_out_bus),
        .regB_out_bus(regB_out_bus),
        .pc_out_bus(pc_out_bus)
    );

    assign o_LED_1 = regA_out_bus[3];
    assign o_LED_2 = regA_out_bus[2];
    assign o_LED_3 = regA_out_bus[1];
    assign o_LED_4 = regA_out_bus[0];

    sevenseg_driver SSEG (
        .value(regA_out_bus),
        .S1_A(S1_A),
        .S1_B(S1_B),
        .S1_C(S1_C),
        .S1_D(S1_D),
        .S1_E(S1_E),
        .S1_F(S1_F),
        .S1_G(S1_G),
        .S2_A(S2_A),
        .S2_B(S2_B),
        .S2_C(S2_C),
        .S2_D(S2_D),
        .S2_E(S2_E),
        .S2_F(S2_F),
        .S2_G(S2_G)
    );

endmodule

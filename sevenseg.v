module sevenseg_driver(
    input [7:0] value,
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

    // Clamp to two decimal digits and obtain tens/units (synthesizable division by constant)
    wire [7:0] value_clamped = (value > 8'd99) ? 8'd99 : value;
    wire [3:0] tens  = value_clamped / 10;
    wire [3:0] units = value_clamped % 10;

    function [6:0] encode;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: encode = 7'b0111111;
                4'd1: encode = 7'b0000110;
                4'd2: encode = 7'b1011011;
                4'd3: encode = 7'b1001111;
                4'd4: encode = 7'b1100110;
                4'd5: encode = 7'b1101101;
                4'd6: encode = 7'b1111101;
                4'd7: encode = 7'b0000111;
                4'd8: encode = 7'b1111111;
                4'd9: encode = 7'b1101111;
                default: encode = 7'b0000000; // blank
            endcase
        end
    endfunction

    wire [6:0] tens_seg  = encode(tens);
    wire [6:0] units_seg = encode(units);

    // Order {g,f,e,d,c,b,a}
    // Go-board seven-seg LEDs are active-low (segment on when output is 0)
    assign S1_G = ~tens_seg[6];
    assign S1_F = ~tens_seg[5];
    assign S1_E = ~tens_seg[4];
    assign S1_D = ~tens_seg[3];
    assign S1_C = ~tens_seg[2];
    assign S1_B = ~tens_seg[1];
    assign S1_A = ~tens_seg[0];

    assign S2_G = ~units_seg[6];
    assign S2_F = ~units_seg[5];
    assign S2_E = ~units_seg[4];
    assign S2_D = ~units_seg[3];
    assign S2_C = ~units_seg[2];
    assign S2_B = ~units_seg[1];
    assign S2_A = ~units_seg[0];

endmodule

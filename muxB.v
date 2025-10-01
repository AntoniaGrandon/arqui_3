module muxB(
    input [7:0] regB,
    input [7:0] literal,
    input sel,
    output reg [7:0] out
);
    always @(*) begin
        case(sel)
            1'b0: out = regB;
            1'b1: out = literal;
        endcase
    end
endmodule
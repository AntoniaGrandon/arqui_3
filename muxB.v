module muxB(
    input [7:0] regB,
    input [7:0] literal,
    input [7:0] mem_data,
    input [1:0] sel,
    output reg [7:0] out
);
    always @(*) begin
        case(sel)
            2'b00: out = regB;
            2'b01: out = literal;
            2'b10: out = mem_data;
            default: out = 8'b0;
        endcase
    end
endmodule
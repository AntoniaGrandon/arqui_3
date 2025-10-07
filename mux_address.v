module mux_address(
    input [7:0] literal,
    input [7:0] regB,
    input sel,
    output reg [7:0] address
);
    always @(*) begin
        case(sel)
            1'b0: address = literal; 
            1'b1: address = regB;
        endcase
    end
endmodule
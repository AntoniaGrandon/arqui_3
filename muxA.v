module muxA(
    input [7:0] regA,      
    input [7:0] regB,      
    input sel,             
    output reg [7:0] out   
);
    always @(*) begin      
        case(sel)
            1'b0: out = regA;  
            1'b1: out = regB;  
        endcase
    end
endmodule
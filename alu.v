module alu(a, b, s, out);
   input [7:0] a, b;
   input [3:0] s;
   output reg [7:0] out;

   always @(*) begin
       case(s)
           4'b0000: out = a + b;    // ADD
           4'b0001: out = a - b;    // SUB
           4'b0010: out = a & b;    // AND
           4'b0011: out = a | b;    // OR
           4'b0100: out = ~a;       // NOT
           4'b0101: out = a ^ b;    // XOR
           4'b0110: out = a << 1;   // SHL
           4'b0111: out = a >> 1;   // SHR
           4'b1000: out = a + 1;    // INC
           4'b1001: out = b;        // MOV (literal o regB)
           default: out = 8'b0;
       endcase
   end
endmodule
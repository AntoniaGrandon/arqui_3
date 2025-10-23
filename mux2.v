module mux2(
   input [7:0] e0,
   input [7:0] e1,
   input       c,
   output reg [7:0] out
);

   always @(*) begin
      if (c == 1'b0)
         out = e0;
      else
         out = e1;
   end

endmodule

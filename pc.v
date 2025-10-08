module pc(clk, pc);
    input clk;
    output reg [7:0] pc;

    initial pc = 0;

    always @(posedge clk) begin
        pc <= pc + 1;
    end
endmodule
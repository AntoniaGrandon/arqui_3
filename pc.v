module pc(
    input clk,
    input jump,
    input [7:0] jump_addr,
    output reg [7:0] pc
);
    initial pc = 0;

    always @(posedge clk) begin
        if (jump) begin
            pc <= jump_addr;
        end else begin
            pc <= pc + 1;
        end
    end
endmodule
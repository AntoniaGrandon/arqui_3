module data_memory(
    input clk,
    input [7:0] address,
    input [7:0] data_in,
    input write_enable,
    output reg [7:0] data_out
);
    reg [7:0] mem [0:255];
    // Memory intentionally left uninitialized so unwritten locations are 'x'

    always @(*) begin
        data_out = mem[address];
    end

    always @(posedge clk) begin
        if (write_enable) begin
            mem[address] = data_in; 
        end
    end
endmodule
module register(clk, data, load, out);
    input clk, load;
    input [7:0] data;
    output reg [7:0] out;

    initial out = 0;

    always @(posedge clk) begin
        if (load) out <= data;
    end
endmodule
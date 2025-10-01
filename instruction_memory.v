module instruction_memory(address, out);
    input [3:0] address;
    output reg [14:0] out;  

    reg [14:0] mem [0:15];

    initial begin
        $readmemb("im.dat", mem);
    end

    always @(*) begin
        out = mem[address];
    end
endmodule
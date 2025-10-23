module instruction_memory(address, out);
    input [7:0] address;
    output reg [14:0] out;  

    reg [14:0] mem [0:255];

    integer i;
    initial begin
        // Initialize memory to NOP (all zeros) to avoid X when file is shorter
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 15'b0;
        end
        $readmemb("im.dat", mem);
    end

    always @(*) begin
        out = mem[address];
    end
endmodule
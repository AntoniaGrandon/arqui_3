module instruction_memory(
    input  [7:0] address,
    output reg [14:0] out
);
    // 256 x 15-bit program ROM (fits full 8-bit address space)
    reg [14:0] mem [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 15'b0; // default NOP
        end

        // Program: countdown regB from 15 to 0 and expose on regA
            mem[8'h00] = 15'b000001100001111; // MOV B, 15
            mem[8'h01] = 15'b100111100000000; // CMP B, 0
            mem[8'h02] = 15'b101100000000100; // JGE 0x04 (while B >= 0)
            mem[8'h03] = 15'b101001100000111; // JMP 0x07 (when B < 0)
            mem[8'h04] = 15'b000000000000000; // MOV A, B (update display)
            mem[8'h05] = 15'b000101100000001; // SUB B, 1
            mem[8'h06] = 15'b101001100000001; // JMP 0x01 (loop)
            mem[8'h07] = 15'b000001100001111; // MOV B, 15 (re-load for next cycle)
            mem[8'h08] = 15'b101001100000100; // JMP 0x04 (display & continue)
    end

    always @(*) begin
        out = mem[address];
    end
endmodule
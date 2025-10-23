module jump_logic (
    input [3:0] jump_cond,  // Condición de salto
    input flag_z,           // Stored Zero flag
    input flag_n,           // Stored Negative flag
    input flag_c,           // Stored Carry flag
    input flag_v,           // Stored Overflow flag
    input flags_write,      // If set, use alu_result flags instead of stored
    input [7:0] alu_result, // ALU result to compute immediate flags
    output reg jump_enable  // Habilitación de salto
);

    reg flag_z_used;
    reg flag_n_used;

    always @(*) begin
        // If flags_write is asserted this cycle, use ALU result to evaluate jump
        if (flags_write) begin
            flag_z_used = (alu_result == 8'b0);
            flag_n_used = alu_result[7];
        end else begin
            flag_z_used = flag_z;
            flag_n_used = flag_n;
        end

        case (jump_cond)
            4'b0000: jump_enable = 1'b1;    // Siempre salta (JMP)
            4'b0001: jump_enable = flag_z_used;  // JEQ
            // JGE: Jump if greater or equal (N == 0)
            4'b0010: jump_enable = ~flag_n_used;
            // JLE: Jump if less or equal (N == 1 or Z == 1)
            4'b0011: jump_enable = flag_n_used | flag_z_used;
            default: jump_enable = 1'b0;    // No salta
        endcase
    end
endmodule

module jump_logic (
    input [3:0] jump_cond,  // Condición de salto
    input flag_z,           // Zero flag
    input flag_n,           // Negative flag
    input flag_c,           // Carry flag
    input flag_v,           // Overflow flag
    output reg jump_enable  // Habilitación de salto
);

    always @(*) begin
        case (jump_cond)
            4'b0000: jump_enable = 1'b1;    // Siempre salta (JMP)
            4'b0001: jump_enable = flag_z;  // Salta si Z=1 (JEQ)
            default: jump_enable = 1'b0;    // No salta
        endcase
    end
endmodule

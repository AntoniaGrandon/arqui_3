module status_register (
    input clk,                    // Reloj
    input rst,                    // Reset asíncrono
    input flags_write,            // Señal de control
    input [7:0] alu_result,       // Resultado de la ALU
    input alu_carry,              // Carry de la ALU
    input alu_overflow,           // Overflow de la ALU
    output reg flag_z,            // Zero flag
    output reg flag_n,            // Negative flag
    output reg flag_c,            // Carry flag
    output reg flag_v             // Overflow flag
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset: todas las flags a 0
            flag_z <= 0;
            flag_n <= 0;
            flag_c <= 0;
            flag_v <= 0;
        end else if (flags_write) begin
            // Actualización de flags
            flag_z <= (alu_result == 8'b0);     // Z flag
            flag_n <= alu_result[7];            // N flag
            flag_c <= alu_carry;                // C flag
            flag_v <= alu_overflow;             // V flag
        end
    end
endmodule

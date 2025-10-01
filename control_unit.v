module control_unit(
    input [6:0] opcode, // opcode de 7 bits (im_out_bus[14:8])
    output reg [3:0] alu_op,
    output reg muxB_sel,
    output reg regA_load,
    output reg regB_load
);
    always @(*) begin
        case (opcode)
            // MOV A, Lit (opcode 0000010)
            7'b0000010: begin
                alu_op    = 4'b1001; 
                muxB_sel  = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // MOV B, Lit (opcode 0000011)
            7'b0000011: begin
                alu_op    = 4'b1001; 
                muxB_sel  = 1;
                regA_load = 0;
                regB_load = 1;
            end
            // MOV A, B (opcode 0000000)
            7'b0000000: begin
                alu_op    = 4'b1001; 
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // MOV B, A (opcode 0000001)
            7'b0000001: begin
                alu_op    = 4'b1001; 
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // ADD A, B (opcode 0000100)
            7'b0000100: begin
                alu_op    = 4'b0000; 
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SHL A, A (opcode 0011100)
            7'b0011100: begin
                alu_op    = 4'b0110; // shift left
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end

            default: begin
                alu_op    = 4'b0000;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 0;
            end
        endcase
    end
endmodule
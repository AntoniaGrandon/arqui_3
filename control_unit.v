module control_unit(
    input [6:0] opcode, // opcode de 7 bits (im_out_bus[14:8])
    output reg [3:0] alu_op,
    output reg muxB_sel,
    output reg regA_load,
    output reg regB_load
);
    always @(*) begin
        case (opcode)
            // MOV A, B (opcode 0000000)
            7'b0000000: begin
                alu_op    = 4'b1001; 
                muxA_sel = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // MOV B, A (opcode 0000001)
            7'b0000001: begin
                alu_op    = 4'b1001; 
                muxA_sel = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // MOV A, Lit (opcode 0000010)
            7'b0000010: begin
                alu_op    = 4'b1001; 
                muxA_sel = 0;
                muxB_sel  = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // MOV B, Lit (opcode 0000011)
            7'b0000011: begin
                alu_op    = 4'b1001; 
                muxA_sel = 0;
                muxB_sel  = 1;
                regA_load = 0;
                regB_load = 1;
            end

            // ADD A, B (opcode 0000100)
            7'b0000100: begin
                alu_op    = 4'b0000; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // ADD B, A 
            7'b0000101: begin
                alu_op = 4'b0000;
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // ADD A, Lit
            7'b0000110: begin
                alu_op = 4'b0000;
                muxA_sel = 0;
                muxB_sel = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // ADD B, Lit
            7'b0000111: begin
                alu_op = 4'b0000;
                muxA_sel = 1;
                muxB_sel = 1;
                regA_load = 0;
                regB_load = 1;
            end

            //SUB A, B
            7'b0001000: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SUB B, A
            7'b0001001: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // SUB A, Lit
            7'b0001010: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 1;
                regA_load = 1;  
                regB_load = 0;
            end
            // SUB B, Lit
            7'b0001011: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 1;
                muxB_sel  = 1;
                regA_load = 0;  
                regB_load = 1;
            end

            // AND A, B
            7'b0001100: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // AND B, A
            7'b0001101: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // AND A, Lit
            7'b0001110: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // AND B, Lit
            7'b0001111: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 1;
                muxB_sel  = 1;
                regA_load = 0;
                regB_load = 1;
            end

            // OR A, B
            7'b0010000: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // OR B, A
            7'b0010001: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // OR A, Lit
            7'b0010010: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // OR B, Lit
            7'b0010011: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 1;
                muxB_sel  = 1;
                regA_load = 0;
                regB_load = 1;
            end

            // NOT A, A
            7'b0010100: begin
                alu_op    = 4'b0100; // not
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // NOT A, B
            7'b0010101: begin
                alu_op    = 4'b0100; // not
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // NOT B, A
            7'b0010110: begin
                alu_op    = 4'b0100; // not
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // NOT B, B
            7'b0010111: begin
                alu_op    = 4'b0100; // not
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end

            // XOR A, B
            7'b0011000: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // XOR B, A
            7'b0011001: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // XOR A, Lit
            7'b0011010: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 1;
                regA_load = 1;
                regB_load = 0;
            end
            // XOR B, Lit
            7'b0011011: begin
                alu_op    = 4'b0101;
                muxA_sel  = 1;
                muxB_sel  = 1;
                regA_load = 0;
                regB_load = 1;
            end

            // SHL A, A (opcode 0011100)
            7'b0011100: begin
                alu_op    = 4'b0110; // shift left
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SHL A, B
            7'b0011101: begin
                alu_op    = 4'b0110; // shift left
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SHL B, A
            7'b0011110: begin
                alu_op    = 4'b0110; // shift left
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // SHL B, B
            7'b0011111: begin
                alu_op    = 4'b0110; // shift left
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end

            // SHR A, A
            7'b0100000: begin
                alu_op    = 4'b0111; // shift right
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SHR A, B
            7'b0100001: begin
                alu_op    = 4'b0111; // shift right
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 1;
                regB_load = 0;
            end
            // SHR B, A
            7'b0100010: begin
                alu_op    = 4'b0111; // shift right
                muxA_sel = 0;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end
            // SHR B, B
            7'b0100011: begin
                alu_op    = 4'b0111; // shift right
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end

            // INC B
            7'b0100100: begin
                alu_op    = 4'b1000; // increment
                muxA_sel = 1;
                muxB_sel = 0;
                regA_load = 0;
                regB_load = 1;
            end


            default: begin
                alu_op    = 4'b0000;
                muxA_sel = 0;
                muxB_sel  = 0;
                regA_load = 0;
                regB_load = 0;
            end
        endcase
    end
endmodule
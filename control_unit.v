module control_unit(
    input [6:0] opcode, // opcode de 7 bits (im_out_bus[14:8])
    output reg [3:0] alu_op,
    output reg muxA_sel,
    output reg [1:0] muxB_sel,
    output reg regA_load,
    output reg regB_load,
    output reg mem_write,
    output reg addr_sel
);
    always @(*) begin
        case (opcode)
            // MOV A, B 
            7'b0000000: begin
                alu_op    = 4'b0000; 
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // MOV B, A 
            7'b0000001: begin
                alu_op    = 4'b0000; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // MOV A, Lit 
            7'b0000010: begin
                alu_op    = 4'b1001; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // MOV B, Lit 
            7'b0000011: begin
                alu_op    = 4'b1001; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // ADD A, B 
            7'b0000100: begin
                alu_op    = 4'b0000; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // ADD B, A 
            7'b0000101: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // ADD A, Lit
            7'b0000110: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // ADD B, Lit
            7'b0000111: begin
                alu_op    = 4'b0000;
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            //SUB A, B
            7'b0001000: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SUB B, A
            7'b0001001: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SUB A, Lit
            7'b0001010: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;  
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SUB B, Lit
            7'b0001011: begin
                alu_op    = 4'b0001; 
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 0;  
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // AND A, B
            7'b0001100: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // AND B, A
            7'b0001101: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // AND A, Lit
            7'b0001110: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // AND B, Lit
            7'b0001111: begin
                alu_op    = 4'b0010; 
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // OR A, B
            7'b0010000: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // OR B, A
            7'b0010001: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // OR A, Lit
            7'b0010010: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // OR B, Lit
            7'b0010011: begin
                alu_op    = 4'b0011; 
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // NOT A, A
            7'b0010100: begin
                alu_op    = 4'b0100; 
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // NOT A, B
            7'b0010101: begin
                alu_op    = 4'b0100; 
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // NOT B, A
            7'b0010110: begin
                alu_op    = 4'b0100; 
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // NOT B, B
            7'b0010111: begin
                alu_op    = 4'b0100; 
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // XOR A, B
            7'b0011000: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // XOR B, A
            7'b0011001: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // XOR A, Lit
            7'b0011010: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // XOR B, Lit
            7'b0011011: begin
                alu_op    = 4'b0101;
                muxA_sel  = 1;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // SHL A, A 
            7'b0011100: begin
                alu_op    = 4'b0110; // shift left
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHL A, B
            7'b0011101: begin
                alu_op    = 4'b0110; 
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHL B, A
            7'b0011110: begin
                alu_op    = 4'b0110; 
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHL B, B
            7'b0011111: begin
                alu_op    = 4'b0110;
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // SHR A, A
            7'b0100000: begin
                alu_op    = 4'b0111; // shift right
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHR A, B
            7'b0100001: begin
                alu_op    = 4'b0111;
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHR B, A
            7'b0100010: begin
                alu_op    = 4'b0111;
                muxA_sel = 0;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SHR B, B
            7'b0100011: begin
                alu_op    = 4'b0111;
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // INC B
            7'b0100100: begin
                alu_op    = 4'b1000;    //increment
                muxA_sel = 1;
                muxB_sel = 2'b00;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end

            // ========== Instrucciones con Direccionamiento ==========
            
            // MOV A, (Dir)
            7'b0100101: begin
                alu_op    = 4'b1001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // MOV B, (Dir)
            7'b0100110: begin
                alu_op    = 4'b1001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // MOV (Dir), A
            7'b0100111: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // MOV (Dir), B
            7'b0101000: begin
                alu_op    = 4'b1001;
                muxA_sel  = 1;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // MOV A, (B)
            7'b0101001: begin
                alu_op    = 4'b1001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // MOV B, (B)
            7'b0101010: begin
                alu_op    = 4'b1001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 1;
            end
            // MOV (B), A
            7'b0101011: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end
            
            // ADD A, (Dir)
            7'b0101100: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // ADD B, (Dir)
            7'b0101101: begin
                alu_op    = 4'b0000;
                muxA_sel  = 1;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // ADD A, (B)
            7'b0101110: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // ADD (Dir)
            7'b0101111: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            
            // SUB A, (Dir)
            7'b0110000: begin
                alu_op    = 4'b0001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SUB B, (Dir)
            7'b0110001: begin
                alu_op    = 4'b0001;
                muxA_sel  = 1;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // SUB A, (B)
            7'b0110010: begin
                alu_op    = 4'b0001;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // SUB (Dir)
            7'b0110011: begin
                alu_op    = 4'b0001;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end

            // AND A, (Dir)
            7'b0110100: begin
                alu_op    = 4'b0010;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // AND B, (Dir)
            7'b0110101: begin
                alu_op    = 4'b0010;
                muxA_sel  = 1;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // AND A, (B)
            7'b0110110: begin
                alu_op    = 4'b0010;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // AND (Dir)
            7'b0110111: begin
                alu_op    = 4'b0010;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            
            // OR A, (Dir)
            7'b0111000: begin
                alu_op    = 4'b0011;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // OR B, (Dir)
            7'b0111001: begin
                alu_op    = 4'b0011;
                muxA_sel  = 1;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // OR A, (B)
            7'b0111010: begin
                alu_op    = 4'b0011;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // OR (Dir)
            7'b0111011: begin
                alu_op    = 4'b0011;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            
            // NOT (Dir), A
            7'b0111100: begin
                alu_op    = 4'b0100;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // NOT (Dir), B
            7'b0111101: begin
                alu_op    = 4'b0100;
                muxA_sel  = 1;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // NOT (B)
            7'b0111110: begin
                alu_op    = 4'b0100;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end
            
            // XOR A, (Dir)
            7'b0111111: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
            // XOR B, (Dir)
            7'b1000000: begin
                alu_op    = 4'b0101;
                muxA_sel  = 1;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;
            end
            // XOR A, (B)
            7'b1000001: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;
            end
            // XOR (Dir)
            7'b1000010: begin
                alu_op    = 4'b0101;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            
            // SHL (Dir), A
            7'b1000011: begin
                alu_op    = 4'b0110;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // SHL (Dir), B
            7'b1000100: begin
                alu_op    = 4'b0110;
                muxA_sel  = 1;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // SHL (B)
            7'b1000101: begin
                alu_op    = 4'b0110;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end
            
            // SHR (Dir), A
            7'b1000110: begin
                alu_op    = 4'b0111;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // SHR (Dir), B
            7'b1000111: begin
                alu_op    = 4'b0111;
                muxA_sel  = 1;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // SHR (B)
            7'b1001000: begin
                alu_op    = 4'b0111;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end
            
            // INC (Dir)
            7'b1001001: begin
                alu_op    = 4'b1000;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // INC (B)
            7'b1001010: begin
                alu_op    = 4'b1000;
                muxA_sel  = 0;
                muxB_sel  = 2'b10;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end
            
            // RST (Dir)
            7'b1001011: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 0;
            end
            // RST (B)
            7'b1001100: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b01;
                regA_load = 0;
                regB_load = 0;
                mem_write = 1;
                addr_sel  = 1;
            end


            default: begin
                alu_op    = 4'b0000;
                muxA_sel  = 0;
                muxB_sel  = 2'b00;
                regA_load = 0;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;
            end
        endcase
    end
endmodule
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
            
            // MOV A, [Dir] - A = Mem[Lit]
            7'b0100101: begin
                alu_op    = 4'b1001;    // MOV
                muxA_sel  = 0;          // No importa
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // MOV B, [Dir] - B = Mem[Lit]
            7'b0100110: begin
                alu_op    = 4'b1001;    // MOV
                muxA_sel  = 0;          // No importa
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // MOV [Dir], A - Mem[Lit] = A
            7'b0100111: begin
                alu_op    = 4'b0000;    // ADD (A+0)
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b01;      // Literal (0)
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // MOV [Dir], B - Mem[Lit] = B
            7'b0101000: begin
                alu_op    = 4'b1001;    // MOV
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b00;      // No importa
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // MOV A, [B] - A = Mem[B]
            7'b0101001: begin
                alu_op    = 4'b1001;    // MOV
                muxA_sel  = 0;          // No importa
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // MOV B, [B] - B = Mem[B]
            7'b0101010: begin
                alu_op    = 4'b1001;    // MOV
                muxA_sel  = 0;          // No importa
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // MOV [B], A - Mem[B] = A
            7'b0101011: begin
                alu_op    = 4'b0000;    // ADD (A+0)
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b01;      // Literal (0)
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // ADD A, [Dir] - A = A + Mem[Lit]
            7'b0101100: begin
                alu_op    = 4'b0000;    // ADD
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // ADD B, [Dir] - B = B + Mem[Lit]
            7'b0101101: begin
                alu_op    = 4'b0000;    // ADD
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // ADD A, [B] - A = A + Mem[B]
            7'b0101110: begin
                alu_op    = 4'b0000;    // ADD
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // ADD [Dir] - Mem[Lit] = A + B
            7'b0101111: begin
                alu_op    = 4'b0000;    // ADD
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // regB
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // SUB A, [Dir] - A = A - Mem[Lit]
            7'b0110000: begin
                alu_op    = 4'b0001;    // SUB
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // SUB B, [Dir] - B = B - Mem[Lit]
            7'b0110001: begin
                alu_op    = 4'b0001;    // SUB
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // SUB A, [B] - A = A - Mem[B]
            7'b0110010: begin
                alu_op    = 4'b0001;    // SUB
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // SUB [Dir] - Mem[Lit] = A - B
            7'b0110011: begin
                alu_op    = 4'b0001;    // SUB
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // regB
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // AND A, [Dir] - A = A & Mem[Lit]
            7'b0110100: begin
                alu_op    = 4'b0010;    // AND
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // AND B, [Dir] - B = B & Mem[Lit]
            7'b0110101: begin
                alu_op    = 4'b0010;    // AND
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // AND A, [B] - A = A & Mem[B]
            7'b0110110: begin
                alu_op    = 4'b0010;    // AND
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // AND [Dir] - Mem[Lit] = A & B
            7'b0110111: begin
                alu_op    = 4'b0010;    // AND
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // regB
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // OR A, [Dir] - A = A | Mem[Lit]
            7'b0111000: begin
                alu_op    = 4'b0011;    // OR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // OR B, [Dir] - B = B | Mem[Lit]
            7'b0111001: begin
                alu_op    = 4'b0011;    // OR
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // OR A, [B] - A = A | Mem[B]
            7'b0111010: begin
                alu_op    = 4'b0011;    // OR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // OR [Dir] - Mem[Lit] = A | B
            7'b0111011: begin
                alu_op    = 4'b0011;    // OR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // regB
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // NOT [Dir], A - Mem[Lit] = ~A
            7'b0111100: begin
                alu_op    = 4'b0100;    // NOT
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // No importa
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // NOT [Dir], B - Mem[Lit] = ~B
            7'b0111101: begin
                alu_op    = 4'b0100;    // NOT
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b00;      // No importa
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
            end
            
            // NOT [B] - Mem[B] = ~A
            7'b0111110: begin
                alu_op    = 4'b0100;    // NOT
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // No importa
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // XOR A, [Dir] - A = A ^ Mem[Lit]
            7'b0111111: begin
                alu_op    = 4'b0101;    // XOR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // XOR B, [Dir] - B = B ^ Mem[Lit]
            7'b1000000: begin
                alu_op    = 4'b0101;    // XOR
                muxA_sel  = 1;          // regB
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 0;
                regB_load = 1;
                mem_write = 0;
                addr_sel  = 0;          // Directo (literal)
            end
            
            // XOR A, [B] - A = A ^ Mem[B]
            7'b1000001: begin
                alu_op    = 4'b0101;    // XOR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b10;      // Memoria
                regA_load = 1;
                regB_load = 0;
                mem_write = 0;
                addr_sel  = 1;          // Indirecto (regB)
            end
            
            // XOR [Dir] - Mem[Lit] = A ^ B
            7'b1000010: begin
                alu_op    = 4'b0101;    // XOR
                muxA_sel  = 0;          // regA
                muxB_sel  = 2'b00;      // regB
                regA_load = 0;          // No cargar registros
                regB_load = 0;
                mem_write = 1;          // Escribir en memoria
                addr_sel  = 0;          // Directo (literal)
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
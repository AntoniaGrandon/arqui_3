module computer(
    input clk,                          // Reloj del sistema
    output [7:0] alu_out_bus,           // Salida de la ALU
    output [7:0] regA_out_bus,          // Salida del registro A
    output [7:0] regB_out_bus           // Salida del registro B
);
    wire [7:0] pc_out_bus;              // Salida del PC (8 bits)
    wire [14:0] im_out_bus;             // Instrucción de 15 bits (7 bits de opcode, 8 bits de literal)
    wire [6:0] opcode = im_out_bus[14:8];   // opcode de 7 bits
    wire [7:0] literal = im_out_bus[7:0];   // literal de 8 bits

    wire [3:0] alu_op;                  // Operación de la ALU (4 bits)
    wire muxA_sel, regA_load, regB_load, mem_write, addr_sel;
    wire flags_write;                  
    wire is_jump;                       
    wire [3:0] jump_cond;               
    wire [7:0] muxA_out_bus;            // Salida de muxA
    wire [7:0] muxB_out_bus;            // Salida de muxB
    wire [1:0] muxB_sel;                // Selección para muxB
    wire [7:0] mem_address;             // Dirección de la memoria
    wire [7:0] mem_data_out;            // Salida de la memoria de datos

    // Instanciación de los módulos

    // PC (Program Counter)
    pc PC(
        .clk(clk),
        .pc(pc_out_bus)                  // Conecta la salida del PC
    );

    // Memoria de instrucciones
    instruction_memory IM(
        .address(pc_out_bus),             // Dirección del PC
        .out(im_out_bus)                  // Instrucción leída
    );

    // Unidad de control (Control Unit)
    control_unit CU(
        .opcode(opcode),                  // opcode de la instrucción
        .alu_op(alu_op),                  // Operación de la ALU
        .muxA_sel(muxA_sel),              // Selección para muxA
        .muxB_sel(muxB_sel),              // Selección para muxB
        .regA_load(regA_load),            // Señal para cargar en regA
        .regB_load(regB_load),            // Señal para cargar en regB
        .mem_write(mem_write),            // Señal para habilitar escritura en memoria
        .addr_sel(addr_sel),              // Selección de dirección para la memoria
        .flags_write(flags_write),        // Señal de escritura en el registro de flags
        .is_jump(is_jump),                // Señal de salto
        .jump_cond(jump_cond)             // Condición de salto
    );

    // Registros A y B
    register regA(
        .clk(clk),
        .data(alu_out_bus),               // Entrada de datos (resultado de la ALU)
        .load(regA_load),                 // Señal de carga de regA
        .out(regA_out_bus)                // Salida del registro A
    );

    register regB(
        .clk(clk),
        .data(alu_out_bus),               // Entrada de datos (resultado de la ALU)
        .load(regB_load),                 // Señal de carga de regB
        .out(regB_out_bus)                // Salida del registro B
    );

    // Multiplexor A (para elegir entre regA y regB)
    muxA muxA_inst(
        .regA(regA_out_bus),
        .regB(regB_out_bus),
        .sel(muxA_sel),
        .out(muxA_out_bus)                // Salida de muxA
    );

    // Multiplexor B (para elegir entre regB, literal o salida de memoria)
    muxB muxB_inst(
        .regB(regB_out_bus),
        .literal(literal),
        .mem_data(mem_data_out),
        .sel(muxB_sel),
        .out(muxB_out_bus)                // Salida de muxB
    );

    // Multiplexor de dirección (para elegir entre literal y regB)
    mux_address addr_mux(
        .literal(literal),
        .regB(regB_out_bus),
        .sel(addr_sel),
        .address(mem_address)             // Dirección de memoria
    );

    // Memoria de datos
    data_memory DATA_MEM(
        .clk(clk),
        .address(mem_address),            // Dirección de memoria
        .data_in(regA_out_bus),           // Entrada de datos (regA)
        .write_enable(mem_write),         // Habilitar escritura
        .data_out(mem_data_out)           // Salida de la memoria
    );

    // ALU (Unidad Aritmético Lógica)
    alu ALU(
        .a(muxA_out_bus),                 // Operando A
        .b(muxB_out_bus),                 // Operando B
        .s(alu_op),                       // Operación de la ALU
        .out(alu_out_bus)                 // Resultado de la ALU
    );

endmodule

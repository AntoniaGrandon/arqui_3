module pc(clk, pc);
    input clk;
    output reg [7:0] pc;  // Cambiado a 8 bits para 256 instrucciones

    initial pc = 8'hFF;  // Empieza en 255, incrementa a 0 en primer ciclo

    always @(posedge clk) begin
        pc <= pc + 1;
    end
endmodule
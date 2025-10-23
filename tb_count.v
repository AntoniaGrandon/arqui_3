module tb_count;
    reg clk = 0;
    // wires from computer
    wire [7:0] alu_out_bus;
    wire [7:0] regA_out_bus;
    wire [7:0] regB_out_bus;

    computer CPU (
        .clk(clk),
        .alu_out_bus(alu_out_bus),
        .regA_out_bus(regA_out_bus),
        .regB_out_bus(regB_out_bus)
    );

    initial begin
        $dumpfile("out/count.vcd");
        $dumpvars(0, tb_count);
        $display("Time \t regA");
        // run for 40 clock cycles
        repeat (40) begin
            #5 clk = 1;
            #5 clk = 0;
            $display("%0t \t %0d", $time/10, regA_out_bus);
        end
        $finish;
    end
endmodule

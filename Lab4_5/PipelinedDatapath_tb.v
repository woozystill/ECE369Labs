
`timescale 1ns / 1ps

module PipelinedDatapath_tb;

    // Testbench signals
    reg Clk;
    reg Reset;

    wire [31:0] PC;
    wire [31:0] Instruction;

    // Instantiate the complete pipelined processor
    PipelinedDatapath uut(
        .Clk(Clk),
        .Reset(Reset),
        .PC(PC),
        .Instruction(Instruction)
    );

    // Generate clock with a 10 ns period
    always #5 Clk = ~Clk;

    // Initialize and run simulation
    initial begin
        Clk = 0;
        Reset = 1;

        // Hold reset for 20 ns
        #20;
        Reset = 0;

        // Run processor for 3000 ns
        #3000;

        $display("Simulation completed.");
        $finish;
    end

    // Monitor processor execution
    always @(negedge Clk) begin
        if (!Reset) begin
            $display("Time=%0t PC=%h Instruction=%h",
                     $time, PC, Instruction);
        end
    end

endmodule


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

        // Run processor for 000 ns
        #3000;

        $display("Simulation completed.");
        $finish;
    end

    // Monitor processor execution
    always @(negedge Clk) begin
        if (!Reset) begin
            $display("Time=%0t PC=%h Instruction=%h",
                     $time, PC, Instruction);

            // Display register write-back activity
            if (uut.WB_RegWrite && uut.WB_DestinationReg != 5'd0) begin
                $display("  Register Write: R%0d = %h",
                         uut.WB_DestinationReg,
                         uut.WB_WriteData);
            end

            // Display memory write activity
            if (uut.MEM_MemWrite) begin
                $display("  Memory Write: Address=%h Data=%h",
                         uut.MEM_ALUResult,
                         uut.MEM_WriteData);
            end
        end
    end

endmodule


`timescale 1ns / 1ps

// ECE369A - Lab 6
// Hazard Detection Unit Testbench

module HazardDetection_tb;

    reg [31:0] ID_Instruction;
    reg EX_RegWrite;
    reg [4:0] EX_DestinationReg;
    reg MEM_RegWrite;
    reg [4:0] MEM_DestinationReg;
    reg WB_RegWrite;
    reg [4:0] WB_DestinationReg;

    wire PCWrite;
    wire IF_IDWrite;
    wire Stall;

    HazardDetection uut(
        .ID_Instruction(ID_Instruction),
        .EX_RegWrite(EX_RegWrite),
        .EX_DestinationReg(EX_DestinationReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_DestinationReg(MEM_DestinationReg),
        .WB_RegWrite(WB_RegWrite),
        .WB_DestinationReg(WB_DestinationReg),
        .PCWrite(PCWrite),
        .IF_IDWrite(IF_IDWrite),
        .Stall(Stall)
    );

    task CheckStall;
        input ExpectedStall;
        begin
            #10;
            if ((Stall !== ExpectedStall) ||
                (PCWrite !== ~ExpectedStall) ||
                (IF_IDWrite !== ~ExpectedStall))
                $display("FAIL: Instruction=%h ExpectedStall=%b ActualStall=%b",
                         ID_Instruction, ExpectedStall, Stall);
            else
                $display("PASS: Instruction=%h Stall=%b",
                         ID_Instruction, Stall);
        end
    endtask

    initial begin
        ID_Instruction = 32'd0;
        EX_RegWrite = 0;
        EX_DestinationReg = 0;
        MEM_RegWrite = 0;
        MEM_DestinationReg = 0;
        WB_RegWrite = 0;
        WB_DestinationReg = 0;

        // Test 1: No dependencies
        ID_Instruction = 32'h012A4020; // add $t0, $t1, $t2
        CheckStall(0);

        // Test 2: EX dependency on rs
        EX_RegWrite = 1;
        EX_DestinationReg = 5'd9; // $t1
        CheckStall(1);

        // Test 3: EX dependency on rt
        EX_DestinationReg = 5'd10; // $t2
        CheckStall(1);

        // Test 4: MEM dependency
        EX_RegWrite = 0;
        MEM_RegWrite = 1;
        MEM_DestinationReg = 5'd9;
        CheckStall(1);

        // Test 5: WB dependency
        MEM_RegWrite = 0;
        WB_RegWrite = 1;
        WB_DestinationReg = 5'd10;
        CheckStall(1);

        // Test 6: Ignore register zero
        WB_DestinationReg = 5'd0;
        CheckStall(0);

        // Test 7: Immediate instruction reads only rs
        ID_Instruction = 32'h21280005; // addi $t0, $t1, 5
        EX_RegWrite = 1;
        EX_DestinationReg = 5'd8; // rt destination, not source
        WB_RegWrite = 0;
        CheckStall(0);

        // Test 8: Immediate instruction depends on rs
        EX_DestinationReg = 5'd9;
        CheckStall(1);

        // Test 9: Store depends on rt
        EX_DestinationReg = 5'd8;
        ID_Instruction = 32'hAD280000; // sw $t0, 0($t1)
        CheckStall(1);

        // Test 10: Branch depends on rs
        ID_Instruction = 32'h11090001; // beq $t0, $t1, 1
        CheckStall(1);

        // Test 11: Jump has no register dependencies
        ID_Instruction = 32'h08000000; // j 0
        CheckStall(0);

        // Test 12: NOP
        ID_Instruction = 32'd0;
        CheckStall(0);

        $display("Hazard detection testbench completed.");
        $finish;
    end

endmodule

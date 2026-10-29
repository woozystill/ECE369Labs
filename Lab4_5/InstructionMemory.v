`timescale 1ns / 1ps
module InstructionMemory(
    input  wire [31:0] Address,
    output wire [31:0] Instruction
);
    reg [31:0] memory [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'h00000000;
        $readmemh("instruction_memory.mem", memory);
    end

    // Word-aligned address. Address[11:2] indexes 1024 instructions.
    assign Instruction = memory[Address[11:2]];
endmodule

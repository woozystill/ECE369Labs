// Lab 5 - FPGA Pipelined MIPS processor
// Team Contributions:
// Zach Scheve - 33%
// Madi Huda - 33%
// Trevor Fife - 34%
//
// Lab 5 integration:
// -ClkDiv
// -Top-Level
// -Seven-Segment display
// -Constraints
// -Post-Implementation Timing

`timescale 1ns / 1ps

module TopLevel(Clk, Reset, out7, en_out, dp);

    input Clk, Reset;
    output [6:0] out7;
    output [3:0] en_out;
    output wire dp;

    wire ClkOut;
    wire [31:0] PCVal;
    wire [31:0] Instruction;
    wire [31:0] RegisterWriteData;
    wire [15:0] Num;

    // Slow clock for the processor
    ClkDiv m1(
        .Clk(Clk),
        .Rst(1'b0),
        .ClkOut(ClkOut)
    );

    // Existing pipelined datapath
    PipelinedDatapath m3(
        .Clk(ClkOut),
        .Reset(Reset),
        .PC(PCVal),
        .Instruction(Instruction),
        .RegisterWriteData(RegisterWriteData)
    );

    // Select PC or register write value
    assign Num = ClkOut ? RegisterWriteData[15:0] : PCVal[15:0];

    // Decimal points ON for PC, OFF for register value
    assign dp = ClkOut;

    // Basys 3 four-digit display
    One4DigitDisplay m2(
        .Clk(Clk),
        .NumberA(Num),
        .out7(out7),
        .en_out(en_out),
        .dp()
    );

endmodule

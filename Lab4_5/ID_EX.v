`timescale 1ns / 1ps
module ID_EX(
    input wire Clk, Reset, Enable, Flush,
    input wire RegWriteIn, MemToRegIn, MemReadIn, MemWriteIn,
    input wire [1:0] MemSizeIn,
    input wire LoadUnsignedIn, RegDstIn, ALUSrcIn,
    input wire [3:0] ALUControlIn,
    input wire [31:0] PCPlus4In, ReadData1In, ReadData2In, ImmediateIn,
    input wire [4:0] RsIn, RtIn, RdIn, ShamtIn,
    output reg RegWriteOut, MemToRegOut, MemReadOut, MemWriteOut,
    output reg [1:0] MemSizeOut,
    output reg LoadUnsignedOut, RegDstOut, ALUSrcOut,
    output reg [3:0] ALUControlOut,
    output reg [31:0] PCPlus4Out, ReadData1Out, ReadData2Out, ImmediateOut,
    output reg [4:0] RsOut, RtOut, RdOut, ShamtOut
);
    always @(posedge Clk) begin
        if (Reset || Flush) begin
            RegWriteOut <= 0; MemToRegOut <= 0; MemReadOut <= 0; MemWriteOut <= 0;
            MemSizeOut <= 0; LoadUnsignedOut <= 0; RegDstOut <= 0; ALUSrcOut <= 0; ALUControlOut <= 0;
            PCPlus4Out <= 0; ReadData1Out <= 0; ReadData2Out <= 0; ImmediateOut <= 0;
            RsOut <= 0; RtOut <= 0; RdOut <= 0; ShamtOut <= 0;
        end else if (Enable) begin
            RegWriteOut <= RegWriteIn; MemToRegOut <= MemToRegIn; MemReadOut <= MemReadIn; MemWriteOut <= MemWriteIn;
            MemSizeOut <= MemSizeIn; LoadUnsignedOut <= LoadUnsignedIn; RegDstOut <= RegDstIn; ALUSrcOut <= ALUSrcIn; ALUControlOut <= ALUControlIn;
            PCPlus4Out <= PCPlus4In; ReadData1Out <= ReadData1In; ReadData2Out <= ReadData2In; ImmediateOut <= ImmediateIn;
            RsOut <= RsIn; RtOut <= RtIn; RdOut <= RdIn; ShamtOut <= ShamtIn;
        end
    end
endmodule

`timescale 1ns / 1ps
module EX_MEM(
    input wire Clk, Reset, Enable, Flush,
    input wire RegWriteIn, MemToRegIn, MemReadIn, MemWriteIn,
    input wire [1:0] MemSizeIn,
    input wire LoadUnsignedIn,
    input wire [31:0] BranchTargetIn, ALUResultIn, WriteDataIn,
    input wire ZeroIn,
    input wire [4:0] DestinationRegIn,
    output reg RegWriteOut, MemToRegOut, MemReadOut, MemWriteOut,
    output reg [1:0] MemSizeOut,
    output reg LoadUnsignedOut,
    output reg [31:0] BranchTargetOut, ALUResultOut, WriteDataOut,
    output reg ZeroOut,
    output reg [4:0] DestinationRegOut
);
    always @(posedge Clk) begin
        if (Reset || Flush) begin
            RegWriteOut <= 0; MemToRegOut <= 0; MemReadOut <= 0; MemWriteOut <= 0;
            MemSizeOut <= 0; LoadUnsignedOut <= 0; BranchTargetOut <= 0;
            ALUResultOut <= 0; WriteDataOut <= 0; ZeroOut <= 0; DestinationRegOut <= 0;
        end else if (Enable) begin
            RegWriteOut <= RegWriteIn; MemToRegOut <= MemToRegIn; MemReadOut <= MemReadIn; MemWriteOut <= MemWriteIn;
            MemSizeOut <= MemSizeIn; LoadUnsignedOut <= LoadUnsignedIn; BranchTargetOut <= BranchTargetIn;
            ALUResultOut <= ALUResultIn; WriteDataOut <= WriteDataIn; ZeroOut <= ZeroIn; DestinationRegOut <= DestinationRegIn;
        end
    end
endmodule

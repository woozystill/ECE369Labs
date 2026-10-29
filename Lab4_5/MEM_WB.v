`timescale 1ns / 1ps
module MEM_WB(
    input wire Clk, Reset, Enable, Flush,
    input wire RegWriteIn, MemToRegIn,
    input wire [31:0] MemoryDataIn, ALUResultIn,
    input wire [4:0] DestinationRegIn,
    output reg RegWriteOut, MemToRegOut,
    output reg [31:0] MemoryDataOut, ALUResultOut,
    output reg [4:0] DestinationRegOut
);
    always @(posedge Clk) begin
        if (Reset || Flush) begin
            RegWriteOut <= 0; MemToRegOut <= 0; MemoryDataOut <= 0;
            ALUResultOut <= 0; DestinationRegOut <= 0;
        end else if (Enable) begin
            RegWriteOut <= RegWriteIn; MemToRegOut <= MemToRegIn; MemoryDataOut <= MemoryDataIn;
            ALUResultOut <= ALUResultIn; DestinationRegOut <= DestinationRegIn;
        end
    end
endmodule

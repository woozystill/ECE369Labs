`timescale 1ns / 1ps
module IF_ID(
    input  wire        Clk,
    input  wire        Reset,
    input  wire        Enable,
    input  wire        Flush,
    input  wire [31:0] PCPlus4In,
    input  wire [31:0] InstructionIn,
    output reg  [31:0] PCPlus4Out,
    output reg  [31:0] InstructionOut
);
    always @(posedge Clk) begin
        if (Reset || Flush) begin
            PCPlus4Out     <= 32'd0;
            InstructionOut <= 32'd0;
        end else if (Enable) begin
            PCPlus4Out     <= PCPlus4In;
            InstructionOut <= InstructionIn;
        end
    end
endmodule

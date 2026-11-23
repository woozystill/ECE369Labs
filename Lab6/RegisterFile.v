`timescale 1ns / 1ps
module RegisterFile(
    input  wire        Clk,
    input  wire        Reset,
    input  wire        RegWrite,
    input  wire [4:0]  ReadRegister1,
    input  wire [4:0]  ReadRegister2,
    input  wire [4:0]  WriteRegister,
    input  wire [31:0] WriteData,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);
    reg [31:0] registers [0:31];
    integer i;

    assign ReadData1 = (ReadRegister1 == 5'd0) ? 32'd0 : registers[ReadRegister1];
    assign ReadData2 = (ReadRegister2 == 5'd0) ? 32'd0 : registers[ReadRegister2];

    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end else begin
            if (RegWrite && (WriteRegister != 5'd0))
                registers[WriteRegister] <= WriteData;
            registers[0] <= 32'd0;
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2026 09:29:27 PM
// Design Name: 
// Module Name: InstructionFetchUnit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionFetchUnit_tb();

    reg Reset;
    
    reg Clk;
    
    wire [31:0] Instruction;
    
    InstructionFetchUnit u0(
        .Instruction(Instruction),
        .Reset(Reset),
        .Clk(Clk)
    );
    
    // Generate a clock with a 20 ns period
    initial begin
        Clk = 1'b0;
        forever #10 Clk = ~Clk;
    end
    
    // Reset the PC, then let fetch unit run
    initial begin
        Reset = 1'b1;
        
        #20;
        Reset = 1'b0;
        
        #120;
        $finish;
    end
    
endmodule

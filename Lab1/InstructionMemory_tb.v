`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory 
// Module - InstructionMemory_tb.v
// Description - Test the 'InstructionMemory_tb.v' module.
////////////////////////////////////////////////////////////////////////////////

module InstructionMemory_tb(); 

    wire [31:0] Instruction;

    reg [31:0] Address;

	InstructionMemory u0(
		.Address(Address),
        .Instruction(Instruction)
	);

	initial begin
	   
	   // Test several instruction addresses
	   Address = 32'd0;
	   #10;
	   
	   Address = 32'd4;
	   #10;
	   
	   Address = 32'd8;
	   #10;
	   
	   Address = 32'd12;
	   #10;
	   
	   Address = 32'd16;
	   #10;
	   
	   Address = 32'd20;
	   #10;
	   
	   $finish;
	
	end

endmodule


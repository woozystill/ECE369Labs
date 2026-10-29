`timescale 1ns / 1ps


module ALU32Bit(
    input      [3:0]  ALUControl,   // operation select
    input      [31:0] A,            // first input
    input      [31:0] B,            // second input
    output     [31:0] ALUResult,    
    output            Zero          
);
    reg [31:0] Result;

    wire [31:0] Product = A * B;

    always @(*) begin
        Result = 32'd0;                       // default: no latches
        case (ALUControl)
            4'b0000: Result = A & B;                                   // AND
            4'b0001: Result = A | B;                                   // OR
            4'b0010: Result = A + B;                                   // ADD
            4'b0011: Result = A - B;                                   // SUB
            4'b0100: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT (signed): 1 if A < B
            4'b0101: Result = ~(A | B);                                // NOR
            4'b0110: Result = A ^ B;                                   // XOR
            4'b0111: Result = B << A[4:0];                             // SLL: shift B left by A[4:0]
            4'b1000: Result = B >> A[4:0];                             // SRL: shift B right fill with 0s
            4'b1001: Result = Product;                                 // MUL: low 32 bits of A * B
            4'b1010: Result = A;                                       // PASS A
            default: Result = 32'd0;                                   // unused codes output 0
        endcase
    end

    assign ALUResult = Result;                
    assign Zero      = (Result == 32'd0);     
endmodule

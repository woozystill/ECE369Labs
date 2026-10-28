`timescale 1ns / 1ps

// one set of inputs per operation (plus a few edge cases: wrap-around, negative operands, shift of negative value)
// waits for ALU to settle, and compares ALUResult and zero flag against expected value. Prints PASS when correct
// check succeeds otherwise FAIL

module ALU32Bit_tb;
    // inputs
    reg  [3:0]  ALUControl;
    reg  [31:0] A, B;
    // outputs
    wire [31:0] ALUResult;
    wire        Zero;
    integer errors = 0;                                         // # failed checks

    // Device under test
    ALU32Bit uut(.ALUControl(ALUControl), .A(A), .B(B), .ALUResult(ALUResult), .Zero(Zero));

    // this tb gives the ALU a test vector and compare against the expected result
    // op         - ALUControl code to test
    // a, b       - operand values
    // exp_result - expected ALUResult (Zero is expected to equal exp_result == 0)
    // name       - label printed if the check fails

    task check(input [3:0] op, input [31:0] a, input [31:0] b, input [31:0] exp_result, input [127:0] name);
        begin
            ALUControl = op; A = a; B = b; #5;                  // give inputs
            if (ALUResult !== exp_result || Zero !== (exp_result == 0)) begin
                $display("FAIL %0s: got %h (Zero=%b), expected %h", name, ALUResult, Zero, exp_result);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        //logic operations
        check(4'b0000, 32'hF0F0F0F0, 32'h0FF00FF0, 32'h00F000F0, "AND");
        check(4'b0001, 32'hF0F0F0F0, 32'h0FF00FF0, 32'hFFF0FFF0, "OR");

        //add/sub(including wrap around and a zero result)
        check(4'b0010, 32'd6,        32'd10,       32'd16,        "ADD");
        check(4'b0010, 32'hFFFFFFFF, 32'd1,        32'd0,         "ADD wrap/zero");   // overflow wraps to 0, Zero = 1
        check(4'b0011, 32'd10,       32'd6,        32'd4,         "SUB");
        check(4'b0011, 32'd5,        32'd5,        32'd0,         "SUB zero");        // equal operands, Zero = 1

        //less than (signed comparison)
        check(4'b0100, 32'd6,        32'd10,       32'd1,         "SLT true");
        check(4'b0100, 32'd10,       32'd6,        32'd0,         "SLT false");
        check(4'b0100, 32'hFFFFFFFB, 32'd0,        32'd1,         "SLT signed");      // -5 < 0

        //NOR/XOR
        check(4'b0101, 32'd6,        32'd10,       32'hFFFFFFF1,  "NOR");
        check(4'b0110, 32'd6,        32'd10,       32'd12,        "XOR");

        //shifts: A is shift amount, B is value being shifted
        check(4'b0111, 32'd3,        32'd4,        32'd32,        "SLL");             // B <- A[4:0]
        check(4'b1000, 32'd2,        32'd64,       32'd16,        "SRL");             // B -> A[4:0]
        check(4'b1000, 32'd1,        32'h80000000, 32'h40000000,  "SRL logical");     // zero fill not sign fill

        //multiply(low 32 bits, pos and neg)
        check(4'b1001, 32'd6,        32'd10,       32'd60,        "MUL");
        check(4'b1001, 32'hFFFFFFFB, 32'd10,       32'hFFFFFFCE,  "MUL neg");         // -5 * 10 = -50

        //pass through B is ignored
        check(4'b1010, 32'h12345678, 32'hDEADBEEF, 32'h12345678,  "PASS A");

        //report
        if (errors == 0) $display("ALU PASS");
        else             $display("ALU %0d errors", errors);
        $finish;
    end
endmodule

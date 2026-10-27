`timescale 1ns / 1ps
// testbench for Controller. Expected value -1 means don't-care.
module Controller_tb;
    reg  [31:0] Instruction;
    wire [1:0]  RegDst;   wire ALUSrc, ShamtSel, ExtOp;
    wire [3:0]  ALUOp;    wire RegWrite, MemRead, MemWrite;
    wire [1:0]  MemSize, MemToReg;
    wire [2:0]  Branch;   wire Jump, JumpReg;

    integer errors = 0;
    integer tests  = 0;

    Controller uut(.Instruction(Instruction), .RegDst(RegDst), .ALUSrc(ALUSrc), .ShamtSel(ShamtSel),
        .ExtOp(ExtOp), .ALUOp(ALUOp), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .MemSize(MemSize), .MemToReg(MemToReg), .Branch(Branch), .Jump(Jump), .JumpReg(JumpReg));

    task chk; input [255:0] sig; input integer got; input integer exp; input [255:0] name;
        begin
            if (exp != -1 && got !== exp) begin
                $display("FAIL %0s: %0s = %0d, expected %0d", name, sig, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    task check;
        input [255:0] name; input [31:0] instr;
        input integer e_RegDst, e_ALUSrc, e_ShamtSel, e_ExtOp, e_ALUOp, e_RegWrite, e_MemRead,
                      e_MemWrite, e_MemSize, e_MemToReg, e_Branch, e_Jump, e_JumpReg;
        begin
            Instruction = instr; #5;
            tests = tests + 1;
            chk("RegDst",RegDst,e_RegDst,name);     chk("ALUSrc",ALUSrc,e_ALUSrc,name);
            chk("ShamtSel",ShamtSel,e_ShamtSel,name); chk("ExtOp",ExtOp,e_ExtOp,name);
            chk("ALUOp",ALUOp,e_ALUOp,name);        chk("RegWrite",RegWrite,e_RegWrite,name);
            chk("MemRead",MemRead,e_MemRead,name);  chk("MemWrite",MemWrite,e_MemWrite,name);
            chk("MemSize",MemSize,e_MemSize,name);  chk("MemToReg",MemToReg,e_MemToReg,name);
            chk("Branch",Branch,e_Branch,name);     chk("Jump",Jump,e_Jump,name);
            chk("JumpReg",JumpReg,e_JumpReg,name);
        end
    endtask

    initial begin
        // check(name, instruction, RegDst, ALUSrc, ShamtSel, ExtOp, ALUOp, RegWrite, MemRead,
        //       MemWrite, MemSize, MemToReg, Branch, Jump, JumpReg)
        check("add", 32'h010950e0, 1, 0, 0, -1, 2, 1, 0, 0, -1, 0, 0, 0, 0);
        check("sub", 32'h010950e2, 1, 0, 0, -1, 3, 1, 0, 0, -1, 0, 0, 0, 0);
        check("and", 32'h010950e4, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0);
        check("or", 32'h010950e5, 1, 0, 0, -1, 1, 1, 0, 0, -1, 0, 0, 0, 0);
        check("nor", 32'h010950e7, 1, 0, 0, -1, 5, 1, 0, 0, -1, 0, 0, 0, 0);
        check("xor", 32'h010950e6, 1, 0, 0, -1, 6, 1, 0, 0, -1, 0, 0, 0, 0);
        check("slt", 32'h010950ea, 1, 0, 0, -1, 4, 1, 0, 0, -1, 0, 0, 0, 0);
        check("sll", 32'h000950c0, 1, 0, 1, -1, 7, 1, 0, 0, -1, 0, 0, 0, 0);
        check("srl", 32'h000950c2, 1, 0, 1, -1, 8, 1, 0, 0, -1, 0, 0, 0, 0);
        check("mul", 32'h710950c2, 1, 0, 0, -1, 9, 1, 0, 0, -1, 0, 0, 0, 0);
        check("jr", 32'h010950c8, -1, -1, 0, -1, 10, 0, 0, 0, -1, -1, 0, 0, 1);
        check("addi", 32'h21091234, 0, 1, 0, 1, 2, 1, 0, 0, -1, 0, 0, 0, 0);
        check("andi", 32'h31091234, 0, 1, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0);
        check("ori", 32'h35091234, 0, 1, 0, 0, 1, 1, 0, 0, -1, 0, 0, 0, 0);
        check("xori", 32'h39091234, 0, 1, 0, 0, 6, 1, 0, 0, -1, 0, 0, 0, 0);
        check("slti", 32'h29091234, 0, 1, 0, 1, 4, 1, 0, 0, -1, 0, 0, 0, 0);
        check("lw", 32'h8d091234, 0, 1, 0, 1, 2, 1, 1, 0, 0, 1, 0, 0, 0);
        check("lh", 32'h85091234, 0, 1, 0, 1, 2, 1, 1, 0, 1, 1, 0, 0, 0);
        check("lb", 32'h81091234, 0, 1, 0, 1, 2, 1, 1, 0, 2, 1, 0, 0, 0);
        check("sw", 32'had091234, -1, 1, 0, 1, 2, 0, 0, 1, 0, -1, 0, 0, 0);
        check("sh", 32'ha5091234, -1, 1, 0, 1, 2, 0, 0, 1, 1, -1, 0, 0, 0);
        check("sb", 32'ha1091234, -1, 1, 0, 1, 2, 0, 0, 1, 2, -1, 0, 0, 0);
        check("beq", 32'h11091234, -1, 0, 0, 1, 3, 0, 0, 0, -1, -1, 1, 0, 0);
        check("bne", 32'h15091234, -1, 0, 0, 1, 3, 0, 0, 0, -1, -1, 2, 0, 0);
        check("bgez", 32'h05011234, -1, -1, 0, 1, 10, 0, 0, 0, -1, -1, 3, 0, 0);
        check("bltz", 32'h05001234, -1, -1, 0, 1, 10, 0, 0, 0, -1, -1, 6, 0, 0);
        check("bgtz", 32'h1d091234, -1, -1, 0, 1, 10, 0, 0, 0, -1, -1, 4, 0, 0);
        check("blez", 32'h19091234, -1, -1, 0, 1, 10, 0, 0, 0, -1, -1, 5, 0, 0);
        check("j", 32'h08000040, -1, -1, 0, -1, -1, 0, 0, 0, -1, -1, 0, 1, 0);
        check("jal", 32'h0c000040, 2, -1, 0, -1, -1, 1, 0, 0, -1, 2, 0, 1, 0);
        check("nop", 32'h00000000, -1, -1, 0, -1, -1, 0, 0, 0, -1, -1, 0, 0, 0);
        if (errors == 0) $display("PASS: all %0d instructions decoded correctly.", tests);
        else             $display("DONE: %0d errors in %0d tests.", errors, tests);
        $finish;
    end
endmodule

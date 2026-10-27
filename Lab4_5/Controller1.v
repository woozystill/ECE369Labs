`timescale 1ns / 1ps

// Combinational decode of one 32 bit instruction (ID stage). Every output is
// given a default value first. Don't care entries from the truth table are 0
//
// Encodings
//   RegDst   : 00 = rt, 01 = rd, 10 = $ra (31)
//   ALUSrc   : 0 = rt value, 1 = immediate
//   ShamtSel : 1 = ALU input A is the shamt field (sll/srl), 0 = rs value
//   ExtOp    : 1 = sign-extend immediate, 0 = zero-extend
//   ALUOp    : see localparams below
//   MemSize  : 00 = word, 01 = halfword, 10 = byte
//   MemToReg : 00 = ALU result, 01 = memory data, 10 = PC+8 (jal)
//   Branch   : see localparams below (000 = no branch)


module Controller(
    input      [31:0] Instruction,
    output reg [1:0]  RegDst,
    output reg        ALUSrc,
    output reg        ShamtSel,
    output reg        ExtOp,
    output reg [3:0]  ALUOp,
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg [1:0]  MemSize,
    output reg [1:0]  MemToReg,
    output reg [2:0]  Branch,
    output reg        Jump,
    output reg        JumpReg
);

    // ALU op codes
    localparam [3:0] ALU_AND  = 4'b0000,
                     ALU_OR   = 4'b0001,
                     ALU_ADD  = 4'b0010,
                     ALU_SUB  = 4'b0011,
                     ALU_SLT  = 4'b0100,
                     ALU_NOR  = 4'b0101,
                     ALU_XOR  = 4'b0110,
                     ALU_SLL  = 4'b0111,
                     ALU_SRL  = 4'b1000,
                     ALU_MUL  = 4'b1001,
                     ALU_PASS = 4'b1010;   // output = input A used by compare with zero branches

    // Branch condition codes
    localparam [2:0] BR_NONE = 3'b000,
                     BR_BEQ  = 3'b001,
                     BR_BNE  = 3'b010,
                     BR_BGEZ = 3'b011,
                     BR_BGTZ = 3'b100,
                     BR_BLEZ = 3'b101,
                     BR_BLTZ = 3'b110;

    wire [5:0] Opcode = Instruction[31:26];
    wire [4:0] Rt     = Instruction[20:16];   // distinguishes bgez / bltz
    wire [5:0] Funct  = Instruction[5:0];

    always @(*) begin
        // defaults = nop
        RegDst   = 2'b00;
        ALUSrc   = 1'b0;
        ShamtSel = 1'b0;
        ExtOp    = 1'b0;
        ALUOp    = ALU_ADD;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemSize  = 2'b00;
        MemToReg = 2'b00;
        Branch   = BR_NONE;
        Jump     = 1'b0;
        JumpReg  = 1'b0;

        if (Instruction != 32'd0) begin   // all 0 word is the nop
            case (Opcode)
                //R-type (SPECIAL)
                6'b000000: begin
                    case (Funct)
                        6'b100000: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_ADD; end // add
                        6'b100010: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_SUB; end // sub
                        6'b100100: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_AND; end // and
                        6'b100101: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_OR;  end // or
                        6'b100111: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_NOR; end // nor
                        6'b100110: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_XOR; end // xor
                        6'b101010: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_SLT; end // slt
                        6'b000000: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_SLL; ShamtSel = 1'b1; end // sll
                        6'b000010: begin RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_SRL; ShamtSel = 1'b1; end // srl
                        6'b001000: begin JumpReg = 1'b1; ALUOp = ALU_PASS; end                 // jr
                        default: ;
                    endcase
                end

                //R-type (SPECIAL2)
                6'b011100: begin
                    if (Funct == 6'b000010) begin                                               // mul
                        RegDst = 2'b01; RegWrite = 1'b1; ALUOp = ALU_MUL;
                    end
                end

                //I-type ALU
                6'b001000: begin ALUSrc = 1'b1; ExtOp = 1'b1; RegWrite = 1'b1; ALUOp = ALU_ADD; end // addi
                6'b001100: begin ALUSrc = 1'b1; ExtOp = 1'b0; RegWrite = 1'b1; ALUOp = ALU_AND; end // andi
                6'b001101: begin ALUSrc = 1'b1; ExtOp = 1'b0; RegWrite = 1'b1; ALUOp = ALU_OR;  end // ori
                6'b001110: begin ALUSrc = 1'b1; ExtOp = 1'b0; RegWrite = 1'b1; ALUOp = ALU_XOR; end // xori
                6'b001010: begin ALUSrc = 1'b1; ExtOp = 1'b1; RegWrite = 1'b1; ALUOp = ALU_SLT; end // slti

                //Loads
                6'b100011: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD; RegWrite = 1'b1;
                                 MemRead = 1'b1; MemToReg = 2'b01; MemSize = 2'b00; end         // lw
                6'b100001: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD; RegWrite = 1'b1;
                                 MemRead = 1'b1; MemToReg = 2'b01; MemSize = 2'b01; end         // lh
                6'b100000: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD; RegWrite = 1'b1;
                                 MemRead = 1'b1; MemToReg = 2'b01; MemSize = 2'b10; end         // lb

                //Stores
                6'b101011: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD;
                                 MemWrite = 1'b1; MemSize = 2'b00; end                          // sw
                6'b101001: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD;
                                 MemWrite = 1'b1; MemSize = 2'b01; end                          // sh
                6'b101000: begin ALUSrc = 1'b1; ExtOp = 1'b1; ALUOp = ALU_ADD;
                                 MemWrite = 1'b1; MemSize = 2'b10; end                          // sb

                //Branches
                6'b000100: begin ExtOp = 1'b1; ALUOp = ALU_SUB;  Branch = BR_BEQ;  end          // beq
                6'b000101: begin ExtOp = 1'b1; ALUOp = ALU_SUB;  Branch = BR_BNE;  end          // bne
                6'b000111: begin ExtOp = 1'b1; ALUOp = ALU_PASS; Branch = BR_BGTZ; end          // bgtz
                6'b000110: begin ExtOp = 1'b1; ALUOp = ALU_PASS; Branch = BR_BLEZ; end          // blez
                6'b000001: begin                                                                 // REGIMM
                    ExtOp = 1'b1; ALUOp = ALU_PASS;
                    if (Rt == 5'b00001)      Branch = BR_BGEZ;                                  // bgez
                    else if (Rt == 5'b00000) Branch = BR_BLTZ;                                  // bltz
                end

                //Jumps
                6'b000010: begin Jump = 1'b1; end                                               // j
                6'b000011: begin Jump = 1'b1; RegDst = 2'b10; RegWrite = 1'b1; MemToReg = 2'b10; end // jal

                default: ;
            endcase
        end
    end

endmodule

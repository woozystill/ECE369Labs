
`timescale 1ns / 1ps

// ECE369A - Lab 6
// Hazard Detection Unit
// Detects register dependencies and stalls the pipeline when needed.

module HazardDetection(
    input wire [31:0] ID_Instruction,

    input wire EX_RegWrite,
    input wire [4:0] EX_DestinationReg,

    input wire MEM_RegWrite,
    input wire [4:0] MEM_DestinationReg,

    input wire WB_RegWrite,
    input wire [4:0] WB_DestinationReg,

    output wire PCWrite,
    output wire IF_IDWrite,
    output wire Stall
);

    // Current instruction fields
    wire [5:0] Opcode;
    wire [5:0] Funct;
    wire [4:0] ID_Rs;
    wire [4:0] ID_Rt;

    assign Opcode = ID_Instruction[31:26];
    assign Funct = ID_Instruction[5:0];
    assign ID_Rs = ID_Instruction[25:21];
    assign ID_Rt = ID_Instruction[20:16];

    // Determine which registers the current instruction reads
    reg UsesRs;
    reg UsesRt;

    always @(*) begin
        UsesRs = 1'b0;
        UsesRt = 1'b0;

        case (Opcode)
            6'b000000: begin
                case (Funct)
                    6'b100000, 6'b100010, 6'b100100,
                    6'b100101, 6'b100111, 6'b100110,
                    6'b101010: begin
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end

                    6'b000000, 6'b000010: begin
                        UsesRt = 1'b1; // sll, srl
                    end

                    6'b001000: begin
                        UsesRs = 1'b1; // jr
                    end

                    default: ;
                endcase
            end

            6'b011100: begin
                if (Funct == 6'b000010) begin
                    UsesRs = 1'b1; // mul
                    UsesRt = 1'b1;
                end
            end

            // Immediate arithmetic and loads
            6'b001000, 6'b001100, 6'b001101,
            6'b001110, 6'b001010,
            6'b100011, 6'b100001, 6'b100000: begin
                UsesRs = 1'b1;
            end

            // Stores and two-register branches
            6'b101011, 6'b101001, 6'b101000,
            6'b000100, 6'b000101: begin
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end

            // Single-register branches
            6'b000001, 6'b000111, 6'b000110: begin
                UsesRs = 1'b1;
            end

            // j, jal, and unsupported instructions
            default: ;
        endcase
    end

    // Check dependencies in EX, MEM, and WB
    wire EX_Hazard;
    wire MEM_Hazard;
    wire WB_Hazard;

    assign EX_Hazard = EX_RegWrite &&
                       (EX_DestinationReg != 5'd0) &&
                       ((UsesRs && (ID_Rs == EX_DestinationReg)) ||
                        (UsesRt && (ID_Rt == EX_DestinationReg)));

    assign MEM_Hazard = MEM_RegWrite &&
                        (MEM_DestinationReg != 5'd0) &&
                        ((UsesRs && (ID_Rs == MEM_DestinationReg)) ||
                         (UsesRt && (ID_Rt == MEM_DestinationReg)));

    assign WB_Hazard = WB_RegWrite &&
                       (WB_DestinationReg != 5'd0) &&
                       ((UsesRs && (ID_Rs == WB_DestinationReg)) ||
                        (UsesRt && (ID_Rt == WB_DestinationReg)));

    // Stall until dependent register values are available
    assign Stall = EX_Hazard || MEM_Hazard || WB_Hazard;

    // Hold PC and IF/ID during a stall
    assign PCWrite = ~Stall;
    assign IF_IDWrite = ~Stall;

endmodule

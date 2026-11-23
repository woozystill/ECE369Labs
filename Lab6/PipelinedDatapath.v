// ECE369A - Labs 4 and 5
// Pipelined Datapath
//
// Team Member Contributions:
// Zach Scheve  - 33%
// Madi Mustafa - 33%
// Trevor Fife  - 34%

`timescale 1ns / 1ps

module PipelinedDatapath(
    input wire Clk,
    input wire Reset,
    output wire [31:0] PC,
    output wire [31:0] Instruction,
    output wire [31:0] RegisterWriteData
);

    // Instruction Fetch (IF) stage
    wire [31:0] CurrentPC;
    wire [31:0] PCPlus4;
    wire [31:0] NextPC;
    wire [31:0] FetchedInstruction;

    // IF/ID pipeline outputs
    wire [31:0] ID_PCPlus4;
    wire [31:0] ID_Instruction;

    // Program Counter
    ProgramCounter PC_Register(
        .Address(NextPC),
        .PCResult(CurrentPC),
        .Reset(Reset),
        .Clk(Clk)
    );

    // PC + 4
    PCAdder PC_Adder(
        .PCResult(CurrentPC),
        .PCAddResult(PCPlus4)
    );

    // Instruction Memory
    InstructionMemory Instruction_Memory(
        .Address(CurrentPC),
        .Instruction(FetchedInstruction)
    );

    // IF/ID Pipeline Register
    IF_ID IF_ID_Register(
        .Clk(Clk),
        .Reset(Reset),
        .Enable(1'b1),
        .Flush(1'b0),
        .PCPlus4In(PCPlus4),
        .InstructionIn(FetchedInstruction),
        .PCPlus4Out(ID_PCPlus4),
        .InstructionOut(ID_Instruction)
    );

    // Outputs for initial testing
    assign PC = CurrentPC;
    assign Instruction = ID_Instruction;

    // Instruction Decode (ID) stage

    // Controller outputs
    wire [1:0] ID_RegDst;
    wire ID_ALUSrc;
    wire ID_ShamtSel;
    wire ID_ExtOp;
    wire [3:0] ID_ALUOp;
    wire ID_RegWrite;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire [1:0] ID_MemSize;
    wire [1:0] ID_MemToReg;
    wire [2:0] ID_Branch;
    wire ID_Jump;
    wire ID_JumpReg;

    // Main Controller
    Controller Main_Controller(
        .Instruction(ID_Instruction),
        .RegDst(ID_RegDst),
        .ALUSrc(ID_ALUSrc),
        .ShamtSel(ID_ShamtSel),
        .ExtOp(ID_ExtOp),
        .ALUOp(ID_ALUOp),
        .RegWrite(ID_RegWrite),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .MemSize(ID_MemSize),
        .MemToReg(ID_MemToReg),
        .Branch(ID_Branch),
        .Jump(ID_Jump),
        .JumpReg(ID_JumpReg)
    );

    // Register File (ID stage)
    wire [31:0] ID_ReadData1;
    wire [31:0] ID_ReadData2;

    // Immediate Extension (ID stage)
    wire [31:0] ID_SignExtended;
    wire [31:0] ID_Immediate;

    SignExtension Immediate_SignExtension(
        .in(ID_Instruction[15:0]),
        .out(ID_SignExtended)
    );

    // Select sign extension or zero extension
    assign ID_Immediate = ID_ExtOp
        ? ID_SignExtended
        : {16'd0, ID_Instruction[15:0]};

    // ID/EX Pipeline Register

    // Outputs to Execute stage
    wire EX_RegWrite;
    wire EX_MemRead;
    wire EX_MemWrite;
    wire [1:0] EX_MemToReg;
    wire [1:0] EX_MemSize;
    wire EX_LoadUnsigned;
    wire EX_ALUSrc;
    wire EX_ShamtSel;
    wire [1:0] EX_RegDst;
    wire [3:0] EX_ALUControl;

    wire [31:0] EX_PCPlus4;
    wire [31:0] EX_ReadData1;
    wire [31:0] EX_ReadData2;
    wire [31:0] EX_Immediate;

    wire [4:0] EX_Rs;
    wire [4:0] EX_Rt;
    wire [4:0] EX_Rd;
    wire [4:0] EX_Shamt;

    ID_EX ID_EX_Register(
        .Clk(Clk),
        .Reset(Reset),
        .Enable(1'b1),
        .Flush(1'b0),

        .RegWriteIn(ID_RegWrite),
        .MemReadIn(ID_MemRead),
        .MemWriteIn(ID_MemWrite),
        .MemToRegIn(ID_MemToReg),
        .MemSizeIn(ID_MemSize),
        .LoadUnsignedIn(1'b0),
        .ALUSrcIn(ID_ALUSrc),
        .ShamtSelIn(ID_ShamtSel),
        .RegDstIn(ID_RegDst),
        .ALUControlIn(ID_ALUOp),

        .PCPlus4In(ID_PCPlus4),
        .ReadData1In(ID_ReadData1),
        .ReadData2In(ID_ReadData2),
        .ImmediateIn(ID_Immediate),

        .RsIn(ID_Instruction[25:21]),
        .RtIn(ID_Instruction[20:16]),
        .RdIn(ID_Instruction[15:11]),
        .ShamtIn(ID_Instruction[10:6]),

        .RegWriteOut(EX_RegWrite),
        .MemReadOut(EX_MemRead),
        .MemWriteOut(EX_MemWrite),
        .MemToRegOut(EX_MemToReg),
        .MemSizeOut(EX_MemSize),
        .LoadUnsignedOut(EX_LoadUnsigned),
        .ALUSrcOut(EX_ALUSrc),
        .ShamtSelOut(EX_ShamtSel),
        .RegDstOut(EX_RegDst),
        .ALUControlOut(EX_ALUControl),

        .PCPlus4Out(EX_PCPlus4),
        .ReadData1Out(EX_ReadData1),
        .ReadData2Out(EX_ReadData2),
        .ImmediateOut(EX_Immediate),

        .RsOut(EX_Rs),
        .RtOut(EX_Rt),
        .RdOut(EX_Rd),
        .ShamtOut(EX_Shamt)
    );

    // Execute (EX) stage

    // ALU operand selection
    wire [31:0] EX_ALU_A;
    wire [31:0] EX_ALU_B;
    wire [31:0] EX_ALUResult;
    wire EX_Zero;

    // Use shift amount for sll and srl
    assign EX_ALU_A = EX_ShamtSel
        ? {27'd0, EX_Shamt}
        : EX_ReadData1;

    // Select register value or immediate
    assign EX_ALU_B = EX_ALUSrc
        ? EX_Immediate
        : EX_ReadData2;

    // Arithmetic Logic Unit
    ALU32Bit Main_ALU(
        .A(EX_ALU_A),
        .B(EX_ALU_B),
        .ALUControl(EX_ALUControl),
        .ALUResult(EX_ALUResult),
        .Zero(EX_Zero)
    );

    // Destination Register Selection (EX stage)
    wire [4:0] EX_DestinationReg;

    assign EX_DestinationReg =
        (EX_RegDst == 2'b00) ? EX_Rt :
        (EX_RegDst == 2'b01) ? EX_Rd :
        (EX_RegDst == 2'b10) ? 5'd31 :
                              5'd0;

    // Select Execute stage result for write-back
    wire [31:0] EX_Result;

    // jal stores PC + 8 as the return address
    assign EX_Result = (EX_MemToReg == 2'b10)
        ? EX_PCPlus4 + 32'd4
        : EX_ALUResult;

    // EX/MEM Pipeline Register

    // Outputs to Memory stage
    wire MEM_RegWrite;
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire [1:0] MEM_MemToReg;
    wire [1:0] MEM_MemSize;
    wire MEM_LoadUnsigned;

    wire [31:0] MEM_BranchTarget;
    wire [31:0] MEM_ALUResult;
    wire [31:0] MEM_WriteData;
    wire MEM_Zero;
    wire [4:0] MEM_DestinationReg;

    EX_MEM EX_MEM_Register(
        .Clk(Clk),
        .Reset(Reset),
        .Enable(1'b1),
        .Flush(1'b0),

        .RegWriteIn(EX_RegWrite),
        .MemReadIn(EX_MemRead),
        .MemWriteIn(EX_MemWrite),
        .MemToRegIn(EX_MemToReg),
        .MemSizeIn(EX_MemSize),
        .LoadUnsignedIn(EX_LoadUnsigned),

        .BranchTargetIn(32'd0),
        .ALUResultIn(EX_Result),
        .WriteDataIn(EX_ReadData2),
        .ZeroIn(EX_Zero),
        .DestinationRegIn(EX_DestinationReg),

        .RegWriteOut(MEM_RegWrite),
        .MemReadOut(MEM_MemRead),
        .MemWriteOut(MEM_MemWrite),
        .MemToRegOut(MEM_MemToReg),
        .MemSizeOut(MEM_MemSize),
        .LoadUnsignedOut(MEM_LoadUnsigned),

        .BranchTargetOut(MEM_BranchTarget),
        .ALUResultOut(MEM_ALUResult),
        .WriteDataOut(MEM_WriteData),
        .ZeroOut(MEM_Zero),
        .DestinationRegOut(MEM_DestinationReg)
    );

    // Memory (MEM) stage

    wire [31:0] MEM_ReadData;

    DataMemory Main_DataMemory(
        .Clk(Clk),
        .Reset(Reset),
        .MemWrite(MEM_MemWrite),
        .MemRead(MEM_MemRead),
        .MemSize(MEM_MemSize),
        .LoadUnsigned(MEM_LoadUnsigned),
        .Address(MEM_ALUResult),
        .WriteData(MEM_WriteData),
        .ReadData(MEM_ReadData)
    );

    // MEM/WB Pipeline Register

    // Outputs to Write Back stage
    wire WB_RegWrite;
    wire [1:0] WB_MemToReg;
    wire [31:0] WB_MemoryData;
    wire [31:0] WB_ALUResult;
    wire [4:0] WB_DestinationReg;

    MEM_WB MEM_WB_Register(
        .Clk(Clk),
        .Reset(Reset),
        .Enable(1'b1),
        .Flush(1'b0),

        .RegWriteIn(MEM_RegWrite),
        .MemToRegIn(MEM_MemToReg),
        .MemoryDataIn(MEM_ReadData),
        .ALUResultIn(MEM_ALUResult),
        .DestinationRegIn(MEM_DestinationReg),

        .RegWriteOut(WB_RegWrite),
        .MemToRegOut(WB_MemToReg),
        .MemoryDataOut(WB_MemoryData),
        .ALUResultOut(WB_ALUResult),
        .DestinationRegOut(WB_DestinationReg)
    );

    // Jump target calculation (ID stage)
    wire [31:0] ID_JumpTarget;

    assign ID_JumpTarget = {
        ID_PCPlus4[31:28],
        ID_Instruction[25:0],
        2'b00
    };

    // Branch target calculation (ID stage)
    wire [31:0] ID_BranchOffset;
    wire [31:0] ID_BranchTarget;

    assign ID_BranchOffset = ID_SignExtended << 2;
    assign ID_BranchTarget = ID_PCPlus4 + ID_BranchOffset;

    // Branch condition logic (ID stage)
    reg ID_BranchTaken;

    always @(*) begin
        ID_BranchTaken = 1'b0;

        case (ID_Branch)
            3'b001: ID_BranchTaken = (ID_ReadData1 == ID_ReadData2); // beq
            3'b010: ID_BranchTaken = (ID_ReadData1 != ID_ReadData2); // bne
            3'b011: ID_BranchTaken = ($signed(ID_ReadData1) >= 0);  // bgez
            3'b100: ID_BranchTaken = ($signed(ID_ReadData1) > 0);   // bgtz
            3'b101: ID_BranchTaken = ($signed(ID_ReadData1) <= 0);  // blez
            3'b110: ID_BranchTaken = ($signed(ID_ReadData1) < 0);   // bltz
            default: ID_BranchTaken = 1'b0;
        endcase
    end

    // Next PC selection
    assign NextPC = ID_JumpReg ? ID_ReadData1 :
        ID_Jump ? ID_JumpTarget :
        ID_BranchTaken ? ID_BranchTarget :
        PCPlus4;

    // Write Back (WB) stage
    wire [31:0] WB_WriteData;

    assign RegisterWriteData = WB_RegWrite ? WB_WriteData : 32'd0;

    // Select memory data for loads, otherwise use ALU result
    assign WB_WriteData = (WB_MemToReg == 2'b01)
        ? WB_MemoryData
        : WB_ALUResult;

    // Register File (ID stage)
    RegisterFile Main_RegisterFile(
        .Clk(Clk),
        .Reset(Reset),
        .RegWrite(WB_RegWrite),
        .ReadRegister1(ID_Instruction[25:21]),
        .ReadRegister2(ID_Instruction[20:16]),
        .WriteRegister(WB_DestinationReg),
        .WriteData(WB_WriteData),
        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2)
    );

endmodule
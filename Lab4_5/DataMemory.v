`timescale 1ns / 1ps
module DataMemory(
    input  wire        Clk,
    input  wire        Reset,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [1:0]  MemSize,       // 00=byte, 01=halfword, 10=word
    input  wire        LoadUnsigned,  // 1=zero extend, 0=sign extend
    input  wire [31:0] Address,
    input  wire [31:0] WriteData,
    output reg  [31:0] ReadData
);
    reg [31:0] memory [0:1023];
    wire [9:0] word_index = Address[11:2];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'h00000000;
        $readmemh("data_memory.mem", memory);
    end

    always @(posedge Clk) begin
        if (Reset) begin
            // Keep initialized memory contents on reset.
        end else if (MemWrite) begin
            case (MemSize)
                2'b00: begin
                    case (Address[1:0])
                        2'b00: memory[word_index][7:0]   <= WriteData[7:0];
                        2'b01: memory[word_index][15:8]  <= WriteData[7:0];
                        2'b10: memory[word_index][23:16] <= WriteData[7:0];
                        2'b11: memory[word_index][31:24] <= WriteData[7:0];
                    endcase
                end
                2'b01: begin
                    if (Address[1] == 1'b0)
                        memory[word_index][15:0] <= WriteData[15:0];
                    else
                        memory[word_index][31:16] <= WriteData[15:0];
                end
                default: memory[word_index] <= WriteData;
            endcase
        end
    end

    always @(*) begin
        ReadData = 32'd0;
        if (MemRead) begin
            case (MemSize)
                2'b00: begin
                    case (Address[1:0])
                        2'b00: ReadData = LoadUnsigned ? {24'd0, memory[word_index][7:0]}   : {{24{memory[word_index][7]}},  memory[word_index][7:0]};
                        2'b01: ReadData = LoadUnsigned ? {24'd0, memory[word_index][15:8]}  : {{24{memory[word_index][15]}}, memory[word_index][15:8]};
                        2'b10: ReadData = LoadUnsigned ? {24'd0, memory[word_index][23:16]} : {{24{memory[word_index][23]}}, memory[word_index][23:16]};
                        2'b11: ReadData = LoadUnsigned ? {24'd0, memory[word_index][31:24]} : {{24{memory[word_index][31]}}, memory[word_index][31:24]};
                    endcase
                end
                2'b01: begin
                    if (Address[1] == 1'b0)
                        ReadData = LoadUnsigned ? {16'd0, memory[word_index][15:0]} : {{16{memory[word_index][15]}}, memory[word_index][15:0]};
                    else
                        ReadData = LoadUnsigned ? {16'd0, memory[word_index][31:16]} : {{16{memory[word_index][31]}}, memory[word_index][31:16]};
                end
                default: ReadData = memory[word_index];
            endcase
        end
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: CONTROL UNIT
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

//`include "defines.v"
/*
`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
*/

module ControlUnit
(
    input[31:0] Istruction, 
    output reg Branch, 
    output reg MemRead, 
    output reg[1:0]MemtoReg, 
    output reg MemWrite, 
    output reg ALUSrcA, 
    output reg RegWrite, 
    output reg ALUSrcB, 
    output reg ConcEn, 
    output reg Shift, 
    output reg JALR,
    output reg JAL,
    output reg [3:0] ALUOp);

    always @(instruction) begin
        case(instruction[6:2])
            `OPCODE_Arith_R: begin
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b0; 
            end
            `OPCODE_Load: begin
                Branch = 1'b0; MemRead = 1'b1; MemtoReg = 2'b01; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end
            `OPCODE_Store: begin
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b00; MemWrite = 1'b1; ALUSrc = 1'b1; RegWrite = 1'b0; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end                                           
            `OPCODE_Branch: begin                               
                Branch = 1'b1; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b01; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite = 1'b0; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b1; JALR =1'b0; JAL = 1'b0;
            end                                           
            `OPCODE_AUIPC: begin                               
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b1; ConcEn = 1'b1; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end                                           
            `OPCODE_Arith_I: begin                               
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end                                           
            `OPCODE_JAL: begin                               
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b1;
            end                                           
            `OPCODE_JALR: begin                               
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b10; ALUOp = 2'b00; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b1; JAL = 1'b0;
            end                                           
            `OPCODE_LUI: begin                               
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b11; ALUOp = 2'b11; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1; 
                AUIPC = 1'b0; ConcEn = 1'b1; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end                                           
            default: begin                                
                Branch = 1'b0; MemRead = 1'b0; MemtoReg = 2'b00; ALUOp = 2'b10; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite = 1'b0; 
                AUIPC = 1'b0; ConcEn = 1'b0; Shift = 1'b0; JALR =1'b0; JAL = 1'b0;
            end
        endcase
    end
endmodule

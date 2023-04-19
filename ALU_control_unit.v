`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 11:55:33 AM
// Design Name: 
// Module Name: ALU_control_unit
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


module ALUControlUnit
(
	input[1:0] ALUOp,
	input[31:0] InReg,
	input ALUSrc,
	output reg[3:0] Select
);

always@(*)
begin
	if (ALUOp == 2'b00) Select = 4'b0000; 	// add
 	else if (ALUOp == 2'b01) Select = 4'b0001;	// sub
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b000 && (InReg[30] ==0 || ALUSrc)) Select = 4'b0000; // add
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b000 && (InReg[30] ==1 && !ALUSrc)) Select = 4'b0001; // sub
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b111 && (InReg[30] ==0 || ALUSrc) ) Select = 4'b0101; // and
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b110 && (InReg[30] ==0 || ALUSrc) ) Select = 4'b0100; // or
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b001 && InReg[30] ==0) Select = 4'b1000; // sll
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b010 && (InReg[30] ==0 || ALUSrc) ) Select = 4'b1101; // slt
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b011 && (InReg[30] ==0 || ALUSrc) ) Select = 4'b1111; // sltu
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b100 && (InReg[30] ==0 || ALUSrc) ) Select = 4'b0111; // xor
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b101 && InReg[30] ==0 ) Select = 4'b1001; // srl
	else if (ALUOp == 2'b10 && InReg[14:12] == 3'b101 && InReg[30] ==1 ) Select = 4'b1010; // sra
	else if (ALUOp == 2'b11 ) Select = 4'b0011; // lui
	// every if should have an else statement
	else Select = 4'b1111;
end

endmodule

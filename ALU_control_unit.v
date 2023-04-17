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


module ALU_control_unit(input[1:0] aluop,input[31:0] inreg,input alusrc,output reg[3:0] select);

always@(*)
begin
	if (aluop == 2'b00) select = 4'b0000; 	// add
 	else if (aluop == 2'b01) select = 4'b0001;	// sub
	else if (aluop == 2'b10 && inreg[14:12] == 3'b000 && (inreg[30] ==0 || alusrc)) select = 4'b0000; // add
	else if (aluop == 2'b10 && inreg[14:12] == 3'b000 && (inreg[30] ==1 && !alusrc)) select = 4'b0001; // sub
	else if (aluop == 2'b10 && inreg[14:12] == 3'b111 && (inreg[30] ==0 || alusrc) ) select = 4'b0101; // and
	else if (aluop == 2'b10 && inreg[14:12] == 3'b110 && (inreg[30] ==0 || alusrc) ) select = 4'b0100; // or
	else if (aluop == 2'b10 && inreg[14:12] == 3'b001 && inreg[30] ==0) select = 4'b1000; // sll
	else if (aluop == 2'b10 && inreg[14:12] == 3'b010 && (inreg[30] ==0 || alusrc) ) select = 4'b1101; // slt
	else if (aluop == 2'b10 && inreg[14:12] == 3'b011 && (inreg[30] ==0 || alusrc) ) select = 4'b1111; // sltu
	else if (aluop == 2'b10 && inreg[14:12] == 3'b100 && (inreg[30] ==0 || alusrc) ) select = 4'b0111; // xor
	else if (aluop == 2'b10 && inreg[14:12] == 3'b101 && inreg[30] ==0 ) select = 4'b1001; // srl
	else if (aluop == 2'b10 && inreg[14:12] == 3'b101 && inreg[30] ==1 ) select = 4'b1010; // sra
	else if (aluop == 2'b11 ) select = 4'b0011; // lui
	else select = 4'b1111;
end

endmodule

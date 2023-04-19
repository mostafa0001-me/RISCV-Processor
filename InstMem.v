`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: Instruction memory
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

module InstMem 
(
 input [5:0] Addr, 
 output [31:0] DataOut
);
 
 reg [31:0] mem [0:63];
 assign DataOut = mem[Addr];
 initial begin
        mem[0]=32'h00000083; 
        mem[1]=32'h00100103 ;                               
        mem[2]=32'h002081b3 ;                               
        mem[3]=32'h40218233 ;                                
        mem[4]=32'h002212b3 ;                               
        mem[5]=32'h0012a333 ;                               
        mem[6]=32'h002333b3;
        mem[7]=32'h0063c433;
        mem[8]=32'h100073;
        mem[9]=32'h0000000f;
        mem[10]=32'h007454b3;
        mem[11]=32'h4020d533;
        mem[12]=32'h0024e5b3;
        mem[13]=32'h00b57633;
        mem[14]=32'h00000073;
        mem[15]=32'h002086b3;
        mem[16]=32'h40208733;
        mem[17]=32'h00508793;
        /*mem[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        mem[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
        mem[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
        mem[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
        mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
        mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1*/
   end

endmodule

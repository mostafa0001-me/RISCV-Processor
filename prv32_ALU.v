
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: ALU module
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

module ALU(	
	input   wire [31:0] A, B,	// in1, in2
	output  reg  [31:0] R,		// ALU_out 
	input   wire [4:0] ShAmt, 	// SHIFT AMOUNT
	output  wire        CF, 	// CARRY FLAG
	output ZF, 			// ZERO FLAG
	output VF, 			// OVERFLOW FLAG
	output SF,			// SIGN FLAG
	input   wire [3:0]  ALUFn	// ALUOP
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    	assign op_b = (~b);
    	//assign shamt = B[4:0];
	assign {CF, add} = ALUFn[0] ? (A + op_b + 1'b1) : (A + B);
    	assign ZF = (add == 0);
    	assign SF = add[31];
	assign VF = (A[31] ^ (op_b[31]) ^ add[31] ^ CF);
    
    wire[31:0] sh;
	shifter shifter0(.A(A), .ShAmt(ShAmt), .Type(ALUFn[1:0]),  .R(sh));
    
    always @ * begin
        R = 0;
        (* parallel_case *)
	    case (ALUFn)
            	// arithmetic
            	4'b00_00 : R = add;
            	4'b00_01 : R = add;
            	4'b00_11 : R = B;
            	// logic
            	4'b01_00:  R = A | B;
            	4'b01_01:  R = A & B;
            	4'b01_11:  R = A ^ B;
            	// shift
            	4'b10_00:  R=sh;
            	4'b10_01:  R=sh;
            	4'b10_10:  R=sh;
            	// slt & sltu
		4'b11_01:  R = {31'b0,(SF != VF)}; 
		4'b11_11:  R = {31'b0,(~CF)};
		default: R=R;
        endcase
    end
endmodule

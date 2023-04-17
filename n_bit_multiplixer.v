`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 01:32:30 PM
// Design Name: 
// Module Name: n_bit_multiplixer
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


module MUX #(parameter n = 32)(input[n-1:0] in1,input[n-1:0] in2,input[n-1:0] in3,input[n-1:0] in4, input[1:0] choose, output reg[n-1:0] out);

    always @(*)begin
        case(choose)
            2'b00: out = in1;
            2'b01: out = in2;
            2'b10: out = in3;
            2'b11: out = in4;
        endcase
    end

endmodule

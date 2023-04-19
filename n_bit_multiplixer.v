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


module MUX 
#(parameter n = 32)
(
    input[n-1:0] In1,
    input[n-1:0] In2,
    input[n-1:0] In3,
    input[n-1:0] In4, 
    input[1:0] Choose, 
    output reg[n-1:0] Out
);

    always @(*)begin
        case(Choose)
            2'b00: Out = In1;
            2'b01: Out = In2;
            2'b10: Out = In3;
            2'b11: Out = In4;
            default: Out = In4;
        endcase
    end
endmodule

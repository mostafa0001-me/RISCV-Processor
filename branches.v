`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 10:21:23 PM
// Design Name: 
// Module Name: branches
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


module branches(
    input branch,
    input [2:0] inst,
    output reg andout,
    input zf,
    input cf,
    input sf,
    input vf
    );
    
    always @(*) begin
        if(branch)begin
            case(inst)
                3'b000: andout = zf;
                3'b001: andout = ~zf;
                3'b100: andout = (sf != vf);
                3'b101: andout = (sf == vf);
                3'b110: andout = ~cf;
                3'b111: andout = cf;
                default: andout = 1'b0;
            endcase
        end
        else
            andout = 1'b0;
    end
    
endmodule

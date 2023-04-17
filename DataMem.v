`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 09:57:26 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem(input clk, input[2:0] choose ,input MemRead, input MemWrite,input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out);
    reg [7:0] mem [0:150];
        always@ (*) begin
        if(MemRead)
            case(choose)
                3'b000:   data_out = {{24{mem[addr][7]}},mem[addr]};
                3'b001:   data_out = {{16{mem[addr][7]}}, mem[addr], mem[addr+1]};
                3'b010:   data_out = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
                3'b100:   data_out = {24'b0, mem[addr]};
                3'b101:   data_out = {16'b0, mem[addr], mem[addr+1]};      
                default:  data_out = 32'b0;
            endcase
        else
            data_out = 32'b0;
    end

    always @(posedge(clk)) begin
        if(MemWrite)
                case(choose)
                    3'b000:  mem[addr] = data_in[7:0];   
                    3'b001:  {mem[addr], mem[addr+1]} = data_in[15:0];
                    3'b010:  {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} = data_in;
                endcase
    end 
    initial begin
        {mem[0], mem[1], mem[2], mem[3]}=32'd218300416;
        {mem[4], mem[5], mem[6], mem[7]}=32'd9;
        {mem[8], mem[9], mem[10], mem[11]}=32'd25;
    end 


endmodule
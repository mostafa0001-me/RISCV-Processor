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


module DataMem
(
    input clk, 
    input[2:0] Choose,
    input MemRead, 
    input MemWrite,
    input [5:0] Addr,
    input [31:0] DataIn,
    output reg [31:0] DataOut
);
    
    reg [7:0] mem [0:150];
        always@ (*) begin
        if(MemRead)
            case(Choose)
                3'b000:   DataOut = {{24{mem[Addr][7]}},mem[Addr]};                     // lb
                3'b001:   DataOut = {{16{mem[Addr][7]}}, mem[Addr], mem[Addr+1]};       // lh
                3'b010:   DataOut = {mem[Addr], mem[Addr+1], mem[Addr+2], mem[Addr+3]}; // lw
                3'b100:   DataOut = {24'b0, mem[Addr]};                                 // lbu
                3'b101:   DataOut = {16'b0, mem[Addr], mem[Addr+1]};                    // lhu
                default:  DataOut = 32'b0;                                              // zero
            endcase
        else
            DataOut = 32'b0;
    end

    always @(posedge(clk)) begin
        if(MemWrite)
                case(choose)
                    3'b000:  mem[Addr] = DataIn[7:0];                                    // sb
                    3'b001:  {mem[Addr], mem[Addr+1]} = DataIn[15:0];                    // sh
                    3'b010:  {mem[Addr], mem[Addr+1], mem[Addr+2], mem[Addr+3]} = DataIn;// sw
                endcase
    end 
    initial begin
        {mem[0], mem[1], mem[2], mem[3]}=32'd218300416;
        {mem[4], mem[5], mem[6], mem[7]}=32'd9;
        {mem[8], mem[9], mem[10], mem[11]}=32'd25;
    end 


endmodule

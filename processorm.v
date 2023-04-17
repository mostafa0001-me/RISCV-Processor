`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2023 08:13:54 PM
// Design Name: 
// Module Name: Processor
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


module Processor(input clk, input reset, input [1:0] LedSel, input [3:0] ssdSel,
    input ssdClk, output reg[15:0] Leds, output [6:0] LED_out, output[3:0] Anode);
    //wires
    reg[12:0] ssd;
    reg[31:0] PC;
    reg[5:0] address;
    wire[31:0] inst;
    wire[31:0] regdata1;
    wire[31:0] regdata2;
    wire[31:0] pc4;
    wire[1:0] aluop;
    wire branch, memread, memwrite, alusrc, regwrite, AUIPC, ConcEn, Shift, JALR, JAL;
    wire[1:0] memtoreg;
    wire[31:0] dataToWrite;
    wire[31:0] immediate;
    //wire[31:0] offset;
    wire[31:0] dataToAlu, dataToAlu1;
    wire[31:0] jumpaddress;
    wire[3:0] alucont;
    wire[31:0] aluoutput;
    wire zf, cf, vf, sf;
    wire andout;
    wire[31:0] memoutput;
    wire[31:0] outputtoPC;
    wire[4:0] shamt;
    wire break, recall;
    //modules
    assign break = (inst[6:2] == 5'b11100) & inst[20];
    assign recall = (((inst[6:2] == 5'b11100) & !inst[20]) | (inst[6:2] == 5'b00011));
    assign shamt = alusrc? immediate: regdata2[4:0];
    branches andd(.branch(branch), .cf(cf), .vf(vf), .zf(zf), .sf(sf), .andout(andout), .inst(inst[14:12]));
    InstMem instout(.addr(PC[7:2]), .data_out(inst));
    assign pc4 = PC + 4;
    control_unit cont(.instruction(inst),.JAL(JAL) ,.AUIPC(AUIPC), .ConcEn(ConcEn), .Shift(Shift), .JALR(JALR) ,.branch(branch), .memread(memread), .memtoreg(memtoreg), .memwrite(memwrite), .alusrc(alusrc), .regwrite(regwrite), .aluop(aluop));
    registerfile#(32) rf(.write(regwrite), .write_data(dataToWrite), .write_address(inst[11:7]), .read_address1(inst[19:15]), .read_address2(inst[24:20]), .R1(regdata1), .R2(regdata2), .reset(reset), .clk(clk));
    ImmGen imm(.Imm(immediate), .IR(inst));
    //shift#(32) sh(.A(immediate), .B(offset));
    assign dataToAlu = alusrc ? immediate: regdata2;
    assign dataToAlu1 = AUIPC ? PC: regdata1;
    assign jumpaddress = JALR ? aluoutput : (break ? PC : (recall? 32'b0 : (PC + immediate)));
    ALU_control_unit contalu(.aluop(aluop), .alusrc(alusrc),.inreg(inst),.select(alucont));
    ALU alu(.shamt(shamt),.a(dataToAlu1),.b(dataToAlu),.alufn(alucont),.zf(zf), .vf(vf), .cf(cf), .sf(sf),.r(aluoutput));
    DataMem mem(.clk(clk), .MemRead(memread), .choose(inst[14:12]), .MemWrite(memwrite),.addr({aluoutput[5:0]}), .data_in(regdata2), .data_out(memoutput));
    MUX mm(.in1(aluoutput), .in2(memoutput), .in3(pc4), .in4(immediate), .choose(memtoreg), .out(dataToWrite));
    assign outputtoPC = (andout | JAL | JALR | break | recall) ? jumpaddress: pc4;
    Four_Digit_Seven_Segment_Driver ssddrive(.clk(ssdClk),.num(ssd),.Anode(Anode),.LED_out(LED_out));
    
    always @(posedge(clk) or posedge(reset))begin
        if(reset)
            PC = 0;
        else
            PC = outputtoPC;
//        address = PC[5:0];
   end
    always @(*) begin   
        case(LedSel)
            2'b00: Leds = inst[15:0];
            2'b01: Leds = inst[31:16];
            2'b10: Leds = {2'b0, aluop,alucont,zf,andout, branch, memread, memtoreg, memwrite, alusrc, regwrite};
            default: Leds = 16'b0;
        endcase
        
        case(ssdSel)
            0: ssd = PC[12:0];
            1: ssd = pc4[12:0];
            2: ssd = jumpaddress[12:0];
            3: ssd = outputtoPC[12:0];
            4: ssd = regdata1[12:0];
            5: ssd = regdata2[12:0];
            6: ssd = dataToWrite[12:0];
            7: ssd = immediate[12:0];
            8: ssd = immediate[12:0];
            9: ssd = dataToAlu[12:0];
            10: ssd = aluoutput[12:0];
            11: ssd = memoutput[12:0];
            default ssd = 13'b0;           
        endcase
    end
endmodule

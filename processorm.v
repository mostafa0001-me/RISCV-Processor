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


module Processor(input clk, input rst, input [1:0] LedSel, input [3:0] ssdSel,
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
    
    Branches andd(.Branch(branch), .CF(cf), .VF(vf), .ZF(zf), .SF(sf), .AndOut(andout), .Inst(inst[14:12]));
    
    InstMem instout(.Addr(PC[7:2]), .DataOut(inst));
    
    assign pc4 = PC + 4;
    
    ControlUnit cont(.Instruction(inst),.Jal(JAL) ,.ALUSrcB(AUIPC), .ConcEn(ConcEn), .Shift(Shift), .Jalr(JALR) ,.Branch(branch), 
                     .MemRead(memread), .MemtoReg(memtoreg), .MemWrite(memwrite), .ALUSrcA(alusrc), .RegWrite(regwrite), .ALUOp(aluop));
    
    RegisterFile#(32) rf(.Write(regwrite), .WriteData(dataToWrite), .WriteAddress(inst[11:7]), .ReadAddress1(inst[19:15]), 
                         .ReadAddress2(inst[24:20]), .R1(regdata1), .R2(regdata2), .rst(reset), .clk(clk));
    
    ImmGen imm(.Imm(immediate), .IR(inst));
    //shift#(32) sh(.A(immediate), .B(offset));
    assign dataToAlu = alusrc ? immediate: regdata2;
    
    assign dataToAlu1 = AUIPC ? PC: regdata1;
    
    assign jumpaddress = JALR ? aluoutput : (break ? PC : (recall? 32'b0 : (PC + immediate)));
    
    ALUControlUnit contalu(.ALUOp(aluop), .ALUSrc(alusrc),.InReg(inst),.Select(alucont));
    
    ALU alu(.ShAmt(shamt),.A(dataToAlu1),.B(dataToAlu),.ALUFn(alucont),.ZF(zf), .VF(vf), .CF(cf), .SF(sf),.R(aluoutput));
    
    DataMem mem(.clk(clk), .MemRead(memread), .Choose(inst[14:12]), .MemWrite(memwrite),
                .Addr({aluoutput[5:0]}), .DataIn(regdata2), .DataOut(memoutput));
    
    MUX mm(.In1(aluoutput), .In2(memoutput), .In3(pc4), .In4(immediate), .Choose(memtoreg), .Out(dataToWrite));
    
    assign outputtoPC = (andout | JAL | JALR | break | recall) ? jumpaddress: pc4;
    
    Four_Digit_Seven_Segment_Driver ssddrive(.clk(ssdClk),.Num(ssd),.Anode(Anode),.LEDOut(LED_out));
    
    always @(posedge(clk) or posedge(reset))begin
        if(rst)
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

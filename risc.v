`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2023 18:29:33
// Design Name: 
// Module Name: riscv
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


/*module riscv;
reg clk,reset;
wire regwrite,alusrc,pcsrc,memwrite;
wire[1:0]immsrc,resultsrc;
wire [2:0]alucontrol;
wire [31:0]instr,readdata;
wire zero;
wire [31:0]pc,aluresult,writedata,result;
wire [31:0]srca,srcb;
wire branch,jump;

datapath dut0(clk,reset,regwrite,immsrc,alusrc,alucontrol,resultsrc,pcsrc,zero,pc,aluresult,writedata,readdata,instr,memwrite,result,srca,srcb);

control_unit dut1(instr[6:0],instr[14:12],instr[30],zero,resultsrc,memwrite,alusrc,regwrite,immsrc,alucontrol,pcsrc,branch,jump);


endmodule*/


module riscv(clk,reset,memwrite,result,target);
input clk,reset;
output [3:0]target;
output memwrite;
output [31:0]result;
wire [31:0]aluresult;
wire [31:0]pc,instr,readdata,writedata;
wire alusrc,jump,branch,regwrite;
wire [1:0]immsrc,resultsrc;
wire zero,pcsrc;
wire [2:0]alucontrol;

datapath dd(clk,reset,regwrite,immsrc,alusrc,alucontrol,resultsrc,pcsrc,zero,pc,aluresult,writedata,readdata,instr,memwrite,result,target);

control_unit ctrl(instr[6:0],instr[14:12],instr[30],zero,resultsrc,memwrite,alusrc,regwrite,immsrc,alucontrol,pcsrc,branch,jump);


endmodule












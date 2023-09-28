
module datapath(clk,reset,regwrite,immsrc,alusrc,alucontrol,resultsrc,pcsrc,zero,pc,aluresult,writedata,readdata,instr,memwrite,result,target);
input clk,reset,regwrite,alusrc,pcsrc,memwrite;
input[1:0]immsrc,resultsrc;
input [2:0]alucontrol;
input [31:0]instr,readdata;
output zero;
output [31:0]pc,aluresult,writedata,result;
wire [4:0]writereg;
wire [31:0]pcplus4,pc_next,pc_branch,immext;
wire [31:0]srca,srcb;
output [3:0]target;

adder a1(pc,32'd1,pcplus4);

adder a2(pc,immext,pc_branch);


mux pc_mux(.in1(pcplus4),.in2(pc_branch),.s(pcsrc),.out(pc_next));

pc_reg p1(pc_next,pc,clk,reset);

register_file rf1(.clk(clk),.reset(reset),.we3(regwrite),.wd3(result),.ra1(instr[19:15]),.ra2(instr[24:20]),.wa3(instr[11:7]),.rd1(srca),.rd2(writedata));

mux srcbmux(writedata,immext,alusrc,srcb);

alu al1(srca,srcb,alucontrol,aluresult,zero);

sign_extent immextend1(instr[31:7],immsrc,immext);

mux3 resultmux(aluresult,readdata,pcplus4,resultsrc,result);

instr_mem imemory(pc,instr);//[7:2]

data_mem memory(.A(aluresult),.datain(writedata),.Rd(readdata),.clk(clk),.write_enable(memwrite),.target(target));


endmodule

//INSTRUCTION MEMORY
module instr_mem(pc,instr);
input [31:0]pc;///31:0
output reg [31:0]instr;
reg [31:0]imem[0:63];
//integer i;
initial begin
$readmemb("fib.mem",imem);
end
always@(*) begin
 instr=imem[pc];//[31:2]
end
endmodule


//DATA MEMORY
module data_mem(A,datain,Rd,clk,write_enable,target);
input [31:0]A,datain;
input clk,write_enable;
output reg[31:0]Rd;
reg [31:0]mem[0:127];
output [10:0]target;

assign target=mem[10][3:0];

always@(*) begin
Rd<=mem[A];
end
always@(posedge clk) begin
if(write_enable) begin
mem[A]<=datain;
end
end

endmodule


//MUX
module mux(in1,in2,s,out);
input [31:0]in1,in2;
input s;
output [31:0]out;
assign out=s?(in2):(in1);
endmodule
//MUX3
module mux3(a0,a1,a2,s,y);
input [31:0]a0,a1,a2;
input [1:0]s;
output reg [31:0]y;
always@(*) begin
y<=a0;
case(s)
2'b00:y<=a0;
2'b01:y<=a1;
2'b10:y<=a2;
endcase
end
endmodule
//ADDER
module adder(in1,in2,out);
input [31:0]in1,in2;
output [31:0]out;

assign out=in1+in2;
endmodule

//ALU
module alu(a,b,sel,alu_out,zf);
input [31:0]a,b;
output reg [31:0]alu_out;
output zf;
input [2:0]sel;

always@(*) begin

case(sel)
3'b000:alu_out<=a+b;
3'b001:alu_out<=a-b;
3'b010:alu_out<=a|b;
3'b011:alu_out<=a&b;
3'b101:alu_out<=a<<b;
default:alu_out<=32'b0;
endcase

end
assign zf=(alu_out==0);
endmodule
//PROGRAM COUNTER
module pc_reg(pc_next,pc,clk,reset);
input [31:0]pc_next;
input clk,reset;
output reg [31:0]pc;

always@(posedge clk or negedge reset) begin
if(!reset) pc<=0;
else 
pc<=pc_next;

end
endmodule

//SIGN EXTENTION
module sign_extent(in,immsrc,immext);
input [31:7]in;
input [1:0]immsrc;
output reg [31:0]immext;
always@(*) begin
case(immsrc)
2'b00:immext<={{20{in[31]}},in[31:20]};  // I type
2'b01:immext<={{20{in[31]}},in[11:7],in[31:25]}; //s type
2'b10:immext<={{19{in[31]}},in[31],in[7],in[30:25],in[11:8],1'b0}; //B type
2'b11:immext<={{12{in[31]}},in[19:12],in[20],in[30:21],1'b0}; // J type
default:immext<=0;
endcase
end
endmodule

module register_file(
    input clk,reset,
input we3,
    input [31:0] wd3,
    input [4:0] ra1,ra2,wa3,

    //Read Ports
    output reg [31:0] rd1,rd2

);
//parameter Total_Register = 2**W_reg_address;
reg [31:0] Register_Internal [0:31];

//read operation
always @(*) begin
    rd1 <= Register_Internal[ra1];
    rd2 <= Register_Internal[ra2];
end

always @(posedge clk or negedge reset) begin
    if (!reset) begin
            Register_Internal[0] <= 32'b0;
    end
    else if (we3) begin
        Register_Internal[wa3] <= wd3;
    end
end


endmodule



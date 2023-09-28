



module control_unit(op,funct3,funct7,zero,resultsrc,memwrite,alusrc,regwrite,immsrc,alucontrol,pcsrc,branch,jump);
input [6:0]op;
input [2:0]funct3;
input funct7;
input zero;
output reg [1:0]immsrc,resultsrc;
output reg[2:0]alucontrol;
output reg memwrite,alusrc,regwrite;
output pcsrc;
reg [1:0]aluop;
output reg branch,jump;
wire out_and1,out_and2;

//assign pcsrc=(branch&zero)|jump;
and a1(out_and1,zero,branch,~funct3[0]);
and a2(out_and2,~zero,branch,funct3[0]);
or a3(pcsrc,out_and1,out_and2,jump);
always@(*) begin
case(op)
7'b0000011: begin //3---lw----load instructions
regwrite=1'b1;
immsrc=2'b00;
alusrc=1'b1;
memwrite=1'b0;
resultsrc=2'b01;
aluop=2'b00;
branch=1'b0;
jump=1'b0;
end
7'b0100011: begin //35------sw stype
regwrite=1'b0;
immsrc=2'b01;
alusrc=1'b1;
memwrite=1'b1;
//resultsrc=2'bxx;
aluop=2'b00;
branch=1'b0;
jump=1'b0;

end
7'b0110011: begin //51------R type
regwrite=1'b1;
//immsrc=2'bxx;
alusrc=1'b0;
memwrite=1'b0;
resultsrc=2'b00;
aluop=2'b10;
branch=1'b0;
jump=1'b0;

end
7'b1100011:begin //99--------beq
regwrite=1'b0;
immsrc=2'b10;
alusrc=1'b0;
memwrite=1'b0;
//resultsrc=2'bxx;
aluop=2'b01;
branch=1'b1;
jump=1'b0;

end
7'b0010011: begin //19----addi
regwrite=1'b1;
immsrc=2'b00;
alusrc=1'b1;
memwrite=1'b0;
resultsrc=2'b00;
aluop=2'b10;//10
branch=1'b0;
jump=1'b0;

end
7'b1101111: begin//111----------jal
regwrite=1'b1;
immsrc=2'b11;
memwrite=1'b0;
resultsrc=2'b10;
branch=1'b0;
jump=1'b1;
end
default: begin
regwrite=1'b0;
immsrc=2'b00;
alusrc=1'b0;
memwrite=1'b0;
resultsrc=2'b00;
aluop=2'b00;
branch=1'b0;
jump=1'b0;
end
endcase

case(aluop) 
2'b00:alucontrol=3'b000;
2'b01:alucontrol=3'b001;
2'b10: begin 
case(funct3)
3'b000:begin
if(op[5]==1 && funct7==1) alucontrol<=3'b001;
else alucontrol<=3'b000;end
3'b010:alucontrol=3'b101; 
3'b110:alucontrol=3'b010 ;
3'b111:alucontrol=3'b011 ; 
default: alucontrol=3'b000;
endcase
end
default: alucontrol=3'b000;
endcase
end
endmodule
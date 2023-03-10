module Control
(
	Op_i, // opcode
	ALUOp_o,
	ALUSrc_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemtoReg_o
);

input [6:0] Op_i;
output [1:0] ALUOp_o;
output ALUSrc_o;
output MemRead_o;
output MemWrite_o;
output RegWrite_o;
output MemtoReg_o;
output Branch_o;

reg [1:0] ALUOp_reg;
reg MemtoReg_reg;

assign ALUOp_o = ALUOp_reg;
assign ALUSrc_o = (Op_i==7'b0010011 || Op_i==7'b0000011 || Op_i==7'b0100011)? 1'b1 : 1'b0; //addi, srai, branch => 0
assign Branch_o = (Op_i==7'b1100011)? 1'b1 : 1'b0;
assign MemRead_o = (Op_i==7'b0000011)? 1'b1 : 1'b0;
assign MemWrite_o = (Op_i==7'b0100011)? 1'b1 : 1'b0;
assign RegWrite_o = (Op_i==7'b0110011 || Op_i==7'b0010011 || Op_i==7'b0000011)? 1'b1 : 1'b0;
assign MemtoReg_o = MemtoReg_reg;

always @(Op_i)
begin
	if(Op_i == 7'b0110011) // R-format
	begin
		ALUOp_reg = 2'b00; 
		MemtoReg_reg = 1'b0;
	end
	else if(Op_i == 7'b0010011) // addi, srai
	begin
		ALUOp_reg = 2'b01; 
		MemtoReg_reg = 1'b0;
	end
	else if(Op_i == 7'b0000011) // lw 
	begin
		ALUOp_reg = 2'b10; 
		MemtoReg_reg = 1'b1;
	end
	else if(Op_i == 7'b0100011) // sw (mem don't care)
	begin
		ALUOp_reg = 2'b10;
	end
	else if(Op_i == 7'b1100011) // beq (mem don't care)
	begin
		ALUOp_reg = 2'b11;
	end
end

endmodule
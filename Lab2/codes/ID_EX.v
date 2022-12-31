module ID_EX
(
	clk_i,
	start_i,
	inst_i,
	inst_o,
	RS1addr_i,
	RS1addr_o,
	RS2addr_i,
	RS2addr_o,
	RDaddr_i,
	RDaddr_o,
	RS1data_i,
	RS1data_o,
	RS2data_i,
	RS2data_o,
	imm_i,
	imm_o,
	ALUOp_i,
	ALUOp_o,
	ALUSrc_i,
	ALUSrc_o,
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,
	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
	ID_EX_flush_i, // TODO: if prediction error
	Predict_i, // TODO: previous predict result => use to detect prediction error
	Predict_o,
	Branch_i,
	Branch_o,
	PC_i,
	PC_o,
	branch_pc_i,
	branch_pc_o
);

input clk_i, start_i;
input      [31:0] inst_i;
output reg [31:0] inst_o;
input      [4:0]  RS1addr_i;
output reg [4:0]  RS1addr_o;
input      [4:0]  RS2addr_i;
output reg [4:0]  RS2addr_o;
input      [4:0]  RDaddr_i;
output reg [4:0]  RDaddr_o;
input      [31:0] RS1data_i;
output reg [31:0] RS1data_o;
input      [31:0] RS2data_i;
output reg [31:0] RS2data_o;
input      [31:0] imm_i;
output reg [31:0] imm_o;
input      [1:0]  ALUOp_i;
output reg [1:0]  ALUOp_o;
input ALUSrc_i;
output reg ALUSrc_o = 1'b0;
input MemRead_i;
output reg MemRead_o = 1'b0;
input MemWrite_i;
output reg MemWrite_o = 1'b0;
input RegWrite_i;
output reg RegWrite_o = 1'b0;
input MemtoReg_i;
output reg MemtoReg_o = 1'b0;

input ID_EX_flush_i; // branch prediction error

input Predict_i;
output reg Predict_o = 1'b0;

input Branch_i;
output reg Branch_o = 1'b0;

input [31:0] PC_i;
input [31:0] branch_pc_i;
output reg [31:0] PC_o = 32'b0;
output reg [31:0] branch_pc_o = 32'b0;


always @(posedge clk_i)
begin
	if(!ID_EX_flush_i)
	begin
		inst_o <= inst_i;
		RS1addr_o <= RS1addr_i;
		RS2addr_o <= RS2addr_i;
		RDaddr_o <= RDaddr_i;
		RS1data_o <= RS1data_i;
		RS2data_o <= RS2data_i;
		imm_o <= imm_i;
		ALUOp_o <= ALUOp_i;
		ALUSrc_o <= ALUSrc_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;

		Predict_o <= Predict_i;
		Branch_o <= Branch_i;
		PC_o <= PC_i;
		branch_pc_o <= branch_pc_i;
	end

	else
	begin
		inst_o <= 32'b0;
		// MemRead_o <= 1'b0;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b0;
		MemtoReg_o <= 1'b0;

		Predict_o <= 1'b0;
		Branch_o <= 1'b0;
		PC_o <= 32'b0;
		branch_pc_o <= 32'b0;

	end
end

endmodule
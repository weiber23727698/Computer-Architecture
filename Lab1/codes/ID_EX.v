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
	MemtoReg_o
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
output reg ALUSrc_o;
input MemRead_i;
output reg MemRead_o;
input MemWrite_i;
output reg MemWrite_o;
input RegWrite_i;
output reg RegWrite_o;
input MemtoReg_i;
output reg MemtoReg_o;

reg [31:0] inst_reg;
reg [4:0]  RS1addr_reg;
reg [4:0]  RS2addr_reg;
reg [4:0]  RDaddr_reg;
reg [31:0] RS1data_reg;
reg [31:0] RS2data_reg;
reg [31:0] imm_reg;
reg [1:0]  ALUOp_reg;
reg ALUSrc_reg;
reg MemRead_reg;
reg MemWrite_reg;
reg RegWrite_reg;
reg MemtoReg_reg;

always @(posedge clk_i or negedge clk_i)
begin
	if(!start_i)
	begin
		RegWrite_reg <= 0;
		MemWrite_reg <= 0;
	end
	else if(clk_i)
	begin
	    inst_reg <= inst_i;
	    RS1addr_reg <= RS1addr_i;
	    RS2addr_reg <= RS2addr_i;
	    RDaddr_reg <= RDaddr_i;
	    RS1data_reg <= RS1data_i;
	    RS2data_reg <= RS2data_i;
	    imm_reg <= imm_i;
	    ALUOp_reg <= ALUOp_i;
	    ALUSrc_reg <= ALUSrc_i;
	    MemRead_reg <= MemRead_i;
	    MemWrite_reg <= MemWrite_i;
	    RegWrite_reg <= RegWrite_i;
	    MemtoReg_reg <= MemtoReg_i;
	end
	
	else if(!clk_i)
	begin
		inst_o <= inst_reg;
		RS1addr_o <= RS1addr_reg;
		RS2addr_o <= RS2addr_reg;
		RDaddr_o <= RDaddr_reg;
		RS1data_o <= RS1data_reg;
		RS2data_o <= RS2data_reg;
		imm_o <= imm_reg;
		ALUOp_o <= ALUOp_reg;
		ALUSrc_o <= ALUSrc_reg;
		MemRead_o <= MemRead_reg;
		MemWrite_o <= MemWrite_reg;
		RegWrite_o <= RegWrite_reg;
		MemtoReg_o <= MemtoReg_reg;
	end
end

endmodule
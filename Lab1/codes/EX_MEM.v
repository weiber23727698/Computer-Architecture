module EX_MEM
(
	clk_i,
	start_i,
	RDaddr_i,
	RDaddr_o,
	RS2data_i,
	RS2data_o,
	ALUResult_i,
	ALUResult_o,
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
input [4:0] RDaddr_i;
output reg [4:0] RDaddr_o;
input [31:0] RS2data_i;
output reg [31:0] RS2data_o;
input [31:0] ALUResult_i;
output reg [31:0] ALUResult_o;
input MemRead_i;
output reg MemRead_o;
input MemWrite_i;
output reg MemWrite_o;
input RegWrite_i;
output reg RegWrite_o;
input MemtoReg_i;
output reg MemtoReg_o;

reg [4:0]  RDaddr_reg;
reg [31:0] RS2data_reg;
reg [31:0] ALUResult_reg;
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
		RDaddr_reg <= RDaddr_i;
		RS2data_reg <= RS2data_i;
		ALUResult_reg <= ALUResult_i;
		MemRead_reg <= MemRead_i;
		MemWrite_reg <= MemWrite_i;
		RegWrite_reg <= RegWrite_i;
		MemtoReg_reg <= MemtoReg_i;
	end
	
	else if(!clk_i)
	begin
		RDaddr_o <= RDaddr_reg;
		RS2data_o <= RS2data_reg;
		ALUResult_o <= ALUResult_reg;
		MemRead_o <= MemRead_reg;
		MemWrite_o <= MemWrite_reg;
		RegWrite_o <= RegWrite_reg;
		MemtoReg_o <= MemtoReg_reg;
	end
end

endmodule
module MEM_WB
(
	clk_i,
	start_i,
	RDaddr_i,
	RDaddr_o,
	ALUResult_i,
	ALUResult_o,
	mem_i,
	mem_o,
	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o
);

input clk_i, start_i;
input [4:0] RDaddr_i;
output reg [4:0] RDaddr_o;
input [31:0] ALUResult_i;
output reg [31:0] ALUResult_o;
input [31:0] mem_i;
output reg [31:0] mem_o;
input RegWrite_i;
output reg RegWrite_o;
input MemtoReg_i;
output reg MemtoReg_o;

always @(posedge clk_i)
begin
	if(!start_i)
	begin
		RegWrite_o <= 0;
	end
	else if(clk_i)
	begin
		RDaddr_o <= RDaddr_i;
		ALUResult_o <= ALUResult_i;
		mem_o <= mem_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
	end

end

endmodule
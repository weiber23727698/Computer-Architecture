module IF_ID
(
	clk_i,
	start_i,
	IF_ID_write_i,
	IF_ID_flush_i,
	PC_i,
	inst_i,
	PC_o,
	inst_o
);

input clk_i, start_i;
input IF_ID_write_i;
input IF_ID_flush_i;
input [31:0] PC_i;
input [31:0] inst_i;

output reg [31:0] PC_o;
output reg [31:0] inst_o;

reg [31:0] PC_reg;
reg [31:0] inst_reg;

always @(posedge clk_i or negedge clk_i)
begin
	if(clk_i && IF_ID_write_i) // no hazard
	begin
		PC_reg <= PC_i;
		inst_reg <= (IF_ID_flush_i) ? 32'b0 : inst_i; // taken branch or not
	end

	if(!clk_i)
	begin
		PC_o <= PC_reg;
		inst_o <= inst_reg;
	end
end

endmodule
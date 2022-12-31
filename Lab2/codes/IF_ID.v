module IF_ID (
    clk_i,
    rst_i, 
    IF_ID_flush_i, // branch predition error
    IF_ID_write_i, // hazard
    inst_i, 
    PC_i,
    inst_o, 
    PC_o
);
input         clk_i, rst_i, IF_ID_flush_i, IF_ID_write_i;
input  [31:0] inst_i, PC_i;
output reg [31:0] inst_o;
output reg [31:0] PC_o = 32'b0;

// TODO 

reg [31:0] PC_reg;
reg [31:0] inst_reg;

always @(posedge clk_i)
begin
	if(IF_ID_flush_i)
	begin
		inst_o <= 32'b0;
	end
	else if(clk_i && IF_ID_write_i) // no hazard
	begin
		PC_o <= PC_i;
		inst_o <= inst_i; // taken branch or not
	end
	// if(!clk_i)
	// begin
	// 	PC_o <= PC_reg;
	// 	inst_o <= inst_reg;
	// end
end

always @(posedge rst_i)
begin
    PC_o <= 32'b0;
	inst_o <= 32'b0;
end

endmodule

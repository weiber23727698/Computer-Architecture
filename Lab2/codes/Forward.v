module Forward
(
	ID_EX_RS1addr_i,
	ID_EX_RS2addr_i,
	EX_MEM_RDaddr_i,
	MEM_WB_RDaddr_i,
	EX_MEM_RegWrite_i,
	MEM_WB_RegWrite_i,
	select1_o,
	select2_o
);

input [4:0] ID_EX_RS1addr_i;
input [4:0] ID_EX_RS2addr_i;
input [4:0] EX_MEM_RDaddr_i;
input [4:0] MEM_WB_RDaddr_i;
input EX_MEM_RegWrite_i;
input MEM_WB_RegWrite_i;

output [1:0] select1_o;
output [1:0] select2_o;

reg [1:0] select1_reg;
reg [1:0] select2_reg;

assign select1_o = select1_reg;
assign select2_o = select2_reg;

always @(ID_EX_RS1addr_i or ID_EX_RS2addr_i or EX_MEM_RDaddr_i or MEM_WB_RDaddr_i or EX_MEM_RegWrite_i or MEM_WB_RegWrite_i)
begin
	if(EX_MEM_RegWrite_i && ID_EX_RS1addr_i==EX_MEM_RDaddr_i && EX_MEM_RDaddr_i!=5'b00000) // EX hazard
	begin
		select1_reg = 2'b10;
	end
	else if(MEM_WB_RegWrite_i && ID_EX_RS1addr_i==MEM_WB_RDaddr_i && MEM_WB_RDaddr_i!=5'b00000) // MEM hazard
	begin
		select1_reg = 2'b01;
	end
	else
	begin
		select1_reg = 2'b00;
	end

	if(EX_MEM_RegWrite_i && ID_EX_RS2addr_i==EX_MEM_RDaddr_i && EX_MEM_RDaddr_i!=5'b00000) // EX hazard
	begin
		select2_reg = 2'b10;
	end
	else if(MEM_WB_RegWrite_i && ID_EX_RS2addr_i==MEM_WB_RDaddr_i && MEM_WB_RDaddr_i!=5'b00000) // MEM hazard
	begin
		select2_reg = 2'b01;
	end
	else
	begin
		select2_reg = 2'b00;
	end
end

endmodule
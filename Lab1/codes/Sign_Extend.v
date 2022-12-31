module Sign_Extend
(
    data_i,
    data_o
);

input [31:0] data_i;

output [31:0] data_o;

reg [11:0] imm_reg;

assign data_o = {{20{imm_reg[11]}}, imm_reg[11:0]};

always @(data_i)
begin
    if(data_i[6:0]==7'b0010011 || data_i[6:0]==7'b0000011) // addi, srai, lw
	begin
		imm_reg[11:0] = data_i[31:20];
	end
	else if(data_i[6:0] == 7'b0100011) // sw
	begin
		imm_reg[4:0] = data_i[11:7];
		imm_reg[11:5] = data_i[31:25];
	end
	else if(data_i[6:0] == 7'b1100011) // beq (assign時，位數都-1)
	begin
		imm_reg[3:0] = data_i[11:8];
		imm_reg[9:4] = data_i[30:25];
		imm_reg[10] = data_i[7];
		imm_reg[11] = data_i[31];
	end
end

endmodule
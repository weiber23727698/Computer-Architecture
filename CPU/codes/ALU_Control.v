module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input [31:0] funct_i;
input [1:0] ALUOp_i; // instruction type

output [2:0] ALUCtrl_o; // alu action

reg [2:0] control_reg; // use in always block (always block裡面只能有register)

assign ALUCtrl_o = control_reg;

always @(funct_i or ALUOp_i) // if one of them change do this always block
begin
    if(ALUOp_i == 2'b00)
    begin
        // $display("============ got here =============");
        if(funct_i[14:12] == 3'b000) // addi
            control_reg = 3'b000; // add
        else if(funct_i[14:12] == 3'b101)// srai
            control_reg = 3'b001; // srai
    end
    else if(funct_i[14:12] == 3'b000)
    begin
        if(funct_i[31:25] == 7'b0000000) // add
            control_reg = 3'b000;
        else if(funct_i[31:25] == 7'b0100000) // sub
            control_reg = 3'b010;
        else if(funct_i[31:25] == 7'b0000001) // mul
            control_reg = 3'b011;
    end
    else if(funct_i[14:12] == 3'b001) // sll
        control_reg = 3'b111;
    else if(funct_i[14:12] == 3'b100) // xor
        control_reg = 3'b100; 
    else if(funct_i[14:12] == 3'b111) // and
        control_reg = 3'b101;
end

endmodule
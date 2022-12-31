module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input [31:0] funct_i;
input [1:0] ALUOp_i; // instruction type

output [2:0] ALUCtrl_o; // ALU action

reg [2:0] control_reg; // use in always block (always block裡面只能有register)

assign ALUCtrl_o = control_reg;

always @(funct_i or ALUOp_i) // if one of them change do this always block
begin
    if(ALUOp_i == 2'b00)
    begin
        if(funct_i[14:12] == 3'b000)
        begin
            if(funct_i[31:25] == 7'b0000000)
            begin
                control_reg = 3'b000; // add
            end
            else if(funct_i[31:25] == 7'b0100000)
            begin
                control_reg = 3'b001; // sub
            end
            else if(funct_i[31:25] == 7'b0000001)
            begin
                control_reg = 3'b010; // mul
            end
        end
        else if(funct_i[14:12] == 3'b111)
        begin
            control_reg = 3'b100; // and
        end
        else if(funct_i[14:12] == 3'b100)
        begin
            control_reg = 3'b101; // xor
        end
        else if(funct_i[14:12] == 3'b001)
        begin
            control_reg = 3'b110; // sll
        end
    end
    else if(ALUOp_i == 2'b01)
    begin
        if(funct_i[14:12] == 3'b000)
        begin
            control_reg = 3'b000; // addi
        end
        else if(funct_i[14:12] == 3'b101)
        begin
            control_reg = 3'b011; // srai
        end
    end
    else if(ALUOp_i == 2'b10)
    begin
        control_reg = 3'b000; // lw, sw
    end
    else if(ALUOp_i == 2'b11)
    begin
        control_reg = 3'b001; // beq
    end
end

endmodule
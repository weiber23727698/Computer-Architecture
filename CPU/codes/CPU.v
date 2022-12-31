module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] ins; // instruction
wire [31:0] pc;
wire zero; // use for branch


Control Control(
    .Op_i       (ins[6:0]),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);



Adder Add_PC(
    .data1_in   (pc),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (), // Add_PC.data_o
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc), 
    .instr_o    (ins)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (ins[19:15]),
    .RS2addr_i   (ins[24:20]),
    .RDaddr_i   (ins[11:7]), //// ins[11:7]
    .RDdata_i   (ALU.data_o), //// ALU.data_o
    .RegWrite_i (), // Control.RegWrite_o 
    .RS1data_o   (ALU.data1_i), 
    .RS2data_o   (MUX_ALUSrc.data1_i) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (), // Registers.RS2data_o
    .data2_i    (), // Sign.Sign_Extend.data_o
    .select_i   (), // Control.ALUSrc_o
    .data_o     (ALU.data2_i)
);



Sign_Extend Sign_Extend(
    .data_i     (ins[31:20]),
    .data_o     (MUX_ALUSrc.data2_i)
);

  

ALU ALU(
    .data1_i    (), // Registers.RS1data_o
    .data2_i    (), // MUX_ALUSrc.data_o
    .ALUCtrl_i  (), //// ALU_Control.ALUCtrl_o
    .data_o     (Registers.RDdata_i),
    .zero_o     (zero)
);



ALU_Control ALU_Control(
    .funct_i    (ins),
    .ALUOp_i    (), //// Control.ALUOp_o
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule


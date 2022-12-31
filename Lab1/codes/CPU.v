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

// instruction related
wire [31:0] ins;
wire [31:0] pc;
wire PC_write;
wire branch_taken;

// register for pipeline control
wire IF_ID_write;
wire MUX_Control_select;

reg branch_taken_reg = 1'b0; // initially no branch
reg PC_write_reg = 1'b1;
reg IF_ID_write_reg = 1'b1; // initially no stall
reg MUX_Control_select_reg = 1'b0; // initially no bubble, thus all control signal as ususal

// use non-blocking assignment in pipeline register
always @(branch_taken)
begin
	branch_taken_reg <= branch_taken;
end

always @(PC_write)
begin
	PC_write_reg <= PC_write;
end

always @(IF_ID_write)
begin
	IF_ID_write_reg <= IF_ID_write;
end

always @(MUX_Control_select)
begin
	MUX_Control_select_reg <= MUX_Control_select;
end


Control Control(
    .Op_i       (IF_ID.inst_o[6:0]), // op code
    .ALUOp_o    (), // MUX_Control.ALUOp_i
	.ALUSrc_o   (), // MUX_Control.ALUSrc_i
	.Branch_o   (), // MUX_Control.Branch_i
	.MemRead_o  (), // MUX_Control.MemRead_i
	.MemWrite_o (), // MUX_Control.MemWrite_i
	.RegWrite_o (), // MUX_Control.RegWrite_i
	.MemtoReg_o () // MUX_Control.MemtoReg_i
);

Adder Add_PC(
    .data1_in   (pc),
    .data2_in   (32'd4),
    .data_o     () // MUX_PC.data1_i
);

Adder Add_PC_branch(
	.data1_in (IF_ID.PC_o),
	.data2_in (Sign_Extend.data_o << 1),
	.data_o  () // MUX_PC.data2_i
);

And And( // branch
	.data1_i (MUX_Control.Branch_o),
	.data2_i ((Registers.RS1data_o==Registers.RS2data_o)? 1'b1 : 1'b0),
	.data_o  (branch_taken)
);

MUX32 MUX_PC( // branch
	.data1_i  (Add_PC.data_o),
	.data2_i  (Add_PC_branch.data_o),
	.select_i (branch_taken_reg),
	.data_o   () // PC.pc_i
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i (PC_write_reg),
    .pc_i       (MUX_PC.data_o),
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc), 
    .instr_o    () // IF_ID.inst_i
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (IF_ID.inst_o[19:15]),
    .RS2addr_i   (IF_ID.inst_o[24:20]),
    .RDaddr_i   (MEM_WB.RDaddr_o),
    .RDdata_i   (MUX_MemtoReg.data_o),
    .RegWrite_i (MEM_WB.RegWrite_o),
    .RS1data_o   (), // to ID_EX.RS1data_i 
    .RS2data_o   () // to ID_EX.RS2data_i
);

MUX32 MUX_ALUSrc(
    .data1_i    (MUX_ALU_data2.data_o),
    .data2_i    (ID_EX.imm_o), 
    .select_i   (ID_EX.ALUSrc_o), 
    .data_o     () // ALU.data2_i
);

Sign_Extend Sign_Extend(
    .data_i     (IF_ID.inst_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (MUX_ALU_data1.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o), 
    .data_o     () // EX_MEM.ALUResult_i
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX.inst_o),
    .ALUOp_i    (ID_EX.ALUOp_o), 
    .ALUCtrl_o  () // ALU.ALUCtrl_i
);

Data_Memory Data_Memory(
	.clk_i      (clk_i),
	.addr_i     (EX_MEM.ALUResult_o),
	.data_i     (EX_MEM.RS2data_o),
	.MemRead_i  (EX_MEM.MemRead_o),
	.MemWrite_i (EX_MEM.MemWrite_o),
	.data_o     () // MEM_WB.mem_i
);

IF_ID IF_ID(
	.clk_i         (clk_i),
	.start_i		(start_i),
	.IF_ID_flush_i (branch_taken_reg),
	.IF_ID_write_i (IF_ID_write_reg), // from Hazard.IF_ID_write_o
	.PC_i          (pc),
	.PC_o          (), // Add_PC_branch.data1_in
	.inst_i        (Instruction_Memory.instr_o),
	.inst_o        (ins) // to sign_extend & ID_EX.inst_i
);

ID_EX ID_EX(
	.clk_i      (clk_i),
	.start_i	(start_i),
	.inst_i     (IF_ID.inst_o),
	.inst_o     (), // ALU_Control.funct_i
	.RS1addr_i   (IF_ID.inst_o[19 : 15]),
	.RS1addr_o   (), // to Forward.ID_EX_RS1addr_i
	.RS2addr_i   (IF_ID.inst_o[24 : 20]),
	.RS2addr_o   (), // to Forward.ID_EX_RS2addr_i
	.RDaddr_i   (IF_ID.inst_o[11 : 7]),
	.RDaddr_o   (), // EX_MEM.RDaddr_i
	.RS1data_i   (Registers.RS1data_o),
	.RS1data_o   (), // MUX_ALU_data1.data1_i
	.RS2data_i   (Registers.RS2data_o),
	.RS2data_o   (), // MUX_ALU_data2.data1_i
	.imm_i      (Sign_Extend.data_o),
	.imm_o      (), // MUX_ALUSrc.data2_i
	.ALUOp_i    (MUX_Control.ALUOp_o),
	.ALUOp_o    (), // ALU_Control.ALUOp_i
	.ALUSrc_i   (MUX_Control.ALUSrc_o),
	.ALUSrc_o   (), // MUX_ALUSrc.select_i
	.MemRead_i  (MUX_Control.MemRead_o),
	.MemRead_o  (), // to EX_MEM.MemRead_i
	.MemWrite_i (MUX_Control.MemWrite_o),
	.MemWrite_o (), // to EX_MEM.MemWrite_i
	.RegWrite_i (MUX_Control.RegWrite_o),
	.RegWrite_o (), // to EX_MEM.RegWrite_i
	.MemtoReg_i (MUX_Control.MemtoReg_o),
	.MemtoReg_o () // to EX_MEM.MemtoReg_i
);

EX_MEM EX_MEM(
	.clk_i       (clk_i),
	.RDaddr_i    (ID_EX.RDaddr_o), 
	.RDaddr_o    (), // to MEM_WB.RDaddr_i
	.RS2data_i    (MUX_ALU_data2.data_o),
	.RS2data_o    (), // Data_Memory.data_i
	.ALUResult_i (ALU.data_o),
	.ALUResult_o (), 
	.MemRead_i   (ID_EX.MemRead_o), 
	.MemRead_o   (), // Data_Memory.MemRead_i
	.MemWrite_i  (ID_EX.MemWrite_o), 
	.MemWrite_o  (), // Data_Memory.MemWrite_i
	.RegWrite_i  (ID_EX.RegWrite_o),
	.RegWrite_o  (), // to MEM_WB.RegWrite_i, Forward.EX_MEM_RegWrite_i
	.MemtoReg_i  (ID_EX.MemtoReg_o),
	.MemtoReg_o  () // to MEM_WB.MemtoReg_i
);

MEM_WB MEM_WB(
	.clk_i       (clk_i),
	.RDaddr_i    (EX_MEM.RDaddr_o),
	.RDaddr_o    (), // to Forward.MEM_WB_RDaddr_i
	.ALUResult_i (EX_MEM.ALUResult_o), 
	.ALUResult_o (), // MUX_MemtoReg.data1_i
	.mem_i       (Data_Memory.data_o),
	.mem_o       (), // MUX_MemtoReg.data2_i
	.RegWrite_i  (EX_MEM.RegWrite_o),
	.RegWrite_o  (), // to Forward.MEM_WB_RegWrite_i
	.MemtoReg_i  (EX_MEM.MemtoReg_o),
	.MemtoReg_o  () // to MUX_MemtoReg.select_i
);

MUX32 MUX_MemtoReg(
	.data1_i  (MEM_WB.ALUResult_o),
	.data2_i  (MEM_WB.mem_o),
	.select_i (MEM_WB.MemtoReg_o),
	.data_o   () // to Register.RDdata_i
);

MUX_Control MUX_Control(
	.select_i   (MUX_Control_select_reg),
	.ALUOp_i    (Control.ALUOp_o),
	.ALUOp_o    (), // ID_EX.ALUOp_i
	.ALUSrc_i   (Control.ALUSrc_o),
	.ALUSrc_o   (), // ID_EX.ALUSrc_i
	.Branch_i   (Control.Branch_o),
	.Branch_o   (),
	.MemRead_i  (Control.MemRead_o),
	.MemRead_o  (), // ID_EX.MemRead_i
	.MemWrite_i (Control.MemWrite_o),
	.MemWrite_o (), // ID_EX.MemWrite_i
	.RegWrite_i (Control.RegWrite_o),
	.RegWrite_o (), // ID_EX.RegWrite_i
	.MemtoReg_i (Control.MemtoReg_o),
	.MemtoReg_o () // ID_EX.MemtoReg_i
);

Forward Forward(
	.ID_EX_RS1addr_i    (ID_EX.RS1addr_o),
	.ID_EX_RS2addr_i    (ID_EX.RS2addr_o),
	.EX_MEM_RDaddr_i   (EX_MEM.RDaddr_o),
	.EX_MEM_RegWrite_i (EX_MEM.RegWrite_o),
	.MEM_WB_RDaddr_i   (MEM_WB.RDaddr_o),
	.MEM_WB_RegWrite_i (MEM_WB.RegWrite_o),
	.select1_o         (), // MUX_ALU_data1.select_i
	.select2_o         () // MUX_ALU_data2.select_i
);

MUX3 MUX_ALU_data1(
	.data1_i  (ID_EX.RS1data_o),
	.data2_i  (MUX_MemtoReg.data_o),
	.data3_i  (EX_MEM.ALUResult_o),
	.select_i (Forward.select1_o),
	.data_o   () // ALU.data1_i
);

MUX3 MUX_ALU_data2(
	.data1_i  (ID_EX.RS2data_o),
	.data2_i  (MUX_MemtoReg.data_o),
	.data3_i  (EX_MEM.ALUResult_o),
	.select_i (Forward.select2_o),
	.data_o   () // MUX_ALUSrc.data2_i
);

// Hazard unit
Hazard Hazard_Detection(
	.ID_EX_MemRead_i (ID_EX.MemRead_o),
	.ID_EX_RDaddr_i  (ID_EX.RDaddr_o),
	.IF_ID_RS1addr_i  (IF_ID.inst_o[19:15]),
	.IF_ID_RS2addr_i  (IF_ID.inst_o[24:20]),
	.select_o        (MUX_Control_select), // NoOp
	.PC_write_o      (PC_write),
	.IF_ID_write_o   (IF_ID_write) // to IF_ID.IF_ID_write_i // use for stall
);

endmodule


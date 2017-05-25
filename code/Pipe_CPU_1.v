//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);

/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
	/*-----For PC Module-----*/
	wire [32-1:0] pc_number;
	wire [32-1:0] pc_number_next;
	wire [32-1:0] pc_number_in;
	/*----------------------------*/
	wire [32-1:0] instruction_o;
	wire [32-1:0] pc_plus_four;
/*--------------------------*/

/*------For IF/ID Reg out------*/
	wire [64-1:0] IFID_o;
/*#############################*/

/**** ID stage ****/
	//
	wire [32-1:0] instruction_IFID_o;
	wire [6-1:0] opcode_IFID_o;
	wire [5-1:0] RSaddr_IFID_o;
	wire [5-1:0] RTaddr_IFID_o;
	wire [5-1:0] RDaddr_IFID_o;
	wire [16-1:0] Second_half_instr_IFID_o;
	/*----For Reg_File Module----*/
	wire [32-1:0] RSdata_o;
	wire [32-1:0] RTdata_o;
	/*---------------------------*/
	/*----For Sign_Extend Module Module----*/
	wire [32-1:0] SE_data_o;
	/*-------------------------------------*/
	wire [32-1:0] pc_plus_four_IFID_o;
	wire [32-1:0] shamt;
	assign shamt = {27'b0,instruction_IFID_o[10:6]};
	assign opcode_IFID_o = instruction_IFID_o[31:26];
	assign RSaddr_IFID_o = instruction_IFID_o[25:21];
	assign RTaddr_IFID_o = instruction_IFID_o[20:16];
	assign RDaddr_IFID_o = instruction_IFID_o[15:11];
	assign Second_half_instr_IFID_o = instruction_IFID_o[15:0];
/*-----------------------------*/
//control signal in ID stage
	/*----For Decoder Module----*/
	wire  Branch_o;
	wire [2-1:0] MemToReg_o;
	wire [2-1:0] BranchType_o;
	//wire  Jump_o;//MUX seven is not used this time
	wire  MemRead_o;
	wire  MemWrite_o;
	wire [3-1:0] ALU_op_o;
	wire  ALUSrc_2_select_o;
	wire  RegWrite_o;
	wire [2-1:0] RegDst_o;
	//wire Jump_type;//MUX eight is not used this time
	wire pre_equal_o;
	wire PCWrite_o;
	wire Flush_IFID_o;
	wire WritePipeReg_IFID_o;
	wire ControlReset_ID_o;
	wire ControlReset_EX_o;
	wire ControlReset_MEM_o;
	wire [14-1:0] control_IDEX_i;
	assign control_IDEX_i = {Branch_o,MemToReg_o,BranchType_o,MemRead_o,MemWrite_o,
	ALU_op_o,ALUSrc_2_select_o,RegWrite_o,RegDst_o};
/**** ID stage End****/

/*------For ID/EX Reg out------Total 189 bits*/
	wire [14-1:0] control_IDEX_o;
	wire [32-1:0] pc_plus_four_IDEX_o;
	wire [32-1:0] shamt_IDEX_o;
	wire [32-1:0] RSdata_IDEX_o;
	wire [32-1:0] RTdata_IDEX_o;
	wire [32-1:0] SE_data_IDEX_o;
	wire [5-1:0] RSaddr_IDEX_o;
	wire [5-1:0] RTaddr_IDEX_o;//also known as RDaddr_1_IDEX_o
	wire [5-1:0] RDaddr_2_IDEX_o;
/*#############################*/

/**** EX stage ****/
	/*For ALU Module*/
	wire [32-1:0] ALU_src_1;
	wire [32-1:0] ALU_src_2;
	wire [32-1:0] result_o;
	wire zero_o;
	/*For Reg_dst_select*/
	wire [5-1:0] WriteReg;
	/*For SLL*/
	wire [32-1:0] SLL_data_o;
	/*For Adder_For_BranchTarget*/
	wire [32-1:0] Branch_target_o;
	wire [32-1:0] opd_1_o;
	wire [32-1:0] opd_2_o;
//control signal
	wire [2-1:0] Src1_Forward_select_o;
	wire [2-1:0] Src2_Forward_select_o;
	wire ALUSrc_2_select_EX = control_IDEX_o[3];
	wire [3-1:0] ALU_op_EX = control_IDEX_o[6:4];
	wire [2-1:0] RegDst_EX = control_IDEX_o[1:0];
	wire MemRead_EX;
	wire [8-1:0] control_EXMEM_i;
	/*For ALU_Ctrl Module*/
	wire ALUSrc_1_select_o;
	wire [4-1:0] ALUCtrl_o;
	assign MemRead_EX = control_IDEX_o[8];
	assign control_EXMEM_i = {control_IDEX_o[14-1:7],control_IDEX_o[2]};
/**** EX stage End****/

/*------For EX/MEM Reg out------*/
	wire [8-1:0] control_EXMEM_o;
	wire [32-1:0] Branch_target_EXMEM_o;
	wire zero_EXMEM_o;
	wire [32-1:0] ALU_result_EXMEM_o;
	wire [32-1:0] RTdata_EXMEM_o;
	wire [5-1:0] WriteReg_EXMEM_o;
	wire [32-1:0] SE_data_EXMEM_o;
/*#############################*/

/**** MEM stage ****/
	wire [32-1:0] MEM_Read_data_o;
	wire type_branch_o;
	wire PCSrc_select_o;
	assign PCSrc_select_o = type_branch_o & Branch_MEM;
//control signal
	wire Branch_MEM;
	wire [2-1:0] BranchType_MEM;
	wire MemRead_MEM;
	wire MemWrite_MEM;
	wire RegWrite_MEM;
	wire [3-1:0] control_MEMWB_i;
	assign Branch_MEM = control_EXMEM_o[7];
	assign BranchType_MEM = control_EXMEM_o[4:3];
	assign MemRead_MEM = control_EXMEM_o[2];
	assign MemWrite_MEM = control_EXMEM_o[1];
	assign RegWrite_MEM = control_EXMEM_o[0];
	assign control_MEMWB_i = {control_EXMEM_o[6:5],control_EXMEM_o[0]};
/**** MEM stage End ****/

/*------For MEM/WB Reg out------*/
	wire [3-1:0] control_MEMWB_o;
	wire [32-1:0] MEM_Read_data_MEMWB_o;
	wire [32-1:0] ALU_result_MEMWB_o;
	wire [5-1:0] WriteReg_MEMWB_o;
	wire [32-1:0] SE_data_MEMWB_o;
/*#############################*/

/**** WB stage ****/
	wire [32-1:0] WriteData_o;
//control signal
	wire [2-1:0] MemToReg_WB;
	wire RegWrite_WB;
	assign MemToReg_WB = control_MEMWB_o[2:1];
	assign RegWrite_WB = control_MEMWB_o[0];
/****************************************
Instnatiate modules
****************************************/
wire fake_jump_type;

//Instantiate the components in IF stage

//First MUX, for selecting next pc number
MUX_2to1 #(.size(32)) PC_num_MUX(
	.data0_i(pc_plus_four),
	.data1_i(Branch_target_EXMEM_o),
	.select_i(PCSrc_select_o),
	.data_o(pc_number_in)
	);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc_number_in),
	.PCWrite_i(PCWrite_o),
	.pc_out_o(pc_number)
        );

Instr_Memory IM(
	.pc_addr_i(pc_number),
	.instr_o(instruction_o)
	    );

Adder Add_pc(
	.src1_i(pc_number),
	.src2_i(32'd4),
	.sum_o(pc_plus_four)
	);


Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({pc_plus_four,instruction_o}),
	.Pipe_Reg_Write_i(WritePipeReg_IFID_o),
	.data_o({pc_plus_four_IFID_o,instruction_IFID_o})
	//.data_o(IFID_o)
	);

//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(RSaddr_IFID_o),
	.RTaddr_i(RTaddr_IFID_o),
	.RDaddr_i(WriteReg_MEMWB_o),//Come from MEM/WB reg
	.RDdata_i(WriteData_o),//Come from the MUX in MEM/WB stage
	.RegWrite_i(RegWrite_WB),//Come from MEM/WB reg,control signal
	.RSdata_o(RSdata_o),
	.RTdata_o(RTdata_o),
	.pre_equal_o(pre_equal_o)
	);

Decoder Control(
	.instr_op_i(opcode_IFID_o),
	.Branch_o(Branch_o),
	.MemToReg_o(MemToReg_o),
	.BranchType_o(BranchType_o),
	.MemRead_o(MemRead_o),
	.MemWrite_o(MemWrite_o),
	.ALU_op_o(ALU_op_o),
	.ALUSrc_o(ALUSrc_2_select_o),
	.RegWrite_o(RegWrite_o),
	.RegDst_o(RegDst_o)
	);

Sign_Extend Sign_Extend(
	.data_i(Second_half_instr_IFID_o),
	.data_o(SE_data_o)
	);

Hazara_Detection_Unit HDU(
	.PCSrc_select_i(PCSrc_select_o),
	.MemRead_EX_i(MemRead_EX),
	.RSaddr_IFID_i(RSaddr_IFID_o),
	.RTaddr_IFID_i(RTaddr_IFID_o),
	.RTaddr_IDEX_i(RTaddr_IDEX_o),
	.PCWrite_o(PCWrite_o),
	.Flush_IFID_o(Flush_IFID_o),
	.WritePipeReg_IFID_o(WritePipeReg_IFID_o),
	.ControlReset_ID_o(ControlReset_ID_o),
	.ControlReset_EX_o(ControlReset_EX_o),
	.ControlReset_MEM_o(ControlReset_MEM_o)
	);

/*
Pipe_Reg #(.size(184)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({control_IDEX_i,IFID_o[63:32],shamt,RSdata_o,RTdata_o,SE_data_o,IFID_o[20:16],IFID_o[15:11]}),
	.data_o({control_IDEX_o,pc_plus_four_IDEX_o,shamt_IDEX_o,RSdata_IDEX_o,RTdata_IDEX_o,SE_data_IDEX_o,RTaddr_IDEX_o,RDaddr_2_IDEX_o})
	);
*/
Pipe_Reg #(.size(189)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({control_IDEX_i, pc_plus_four_IFID_o, shamt, RSdata_o, RTdata_o, SE_data_o, RSaddr_IFID_o, RTaddr_IFID_o, RDaddr_IFID_o}),
	.Pipe_Reg_Write_i(1'b1),
	.data_o({control_IDEX_o,pc_plus_four_IDEX_o,shamt_IDEX_o,RSdata_IDEX_o,RTdata_IDEX_o,SE_data_IDEX_o,RSaddr_IDEX_o,RTaddr_IDEX_o,RDaddr_2_IDEX_o})
	);
/*
-----In------
Branch_o,1
MemToReg_o,2
BranchType_o,2
MemRead_o,1
MemWrite_o,1
ALU_op_o,3
ALUSrc_2_select_o,1
RegWrite_o,1
RegDst_o,2
total: 14bits
----Out----
Branch_o,1
MemToReg_o,2
BranchType_o,2
MemRead_o,1
MemWrite_o,1
RegWrite_o,1
total: 8bits
*/
//Instantiate the components in EX stage
ALU_Ctrl ALU_Ctrl(
	.funct_i(SE_data_IDEX_o[6-1:0]),
	.ALUOp_i(ALU_op_EX),
	.ALUCtrl_o(ALUCtrl_o),
	.ALUSrc_1_o(ALUSrc_1_select_o),
	.Jump_type(fake_jump_type)
	);
Forwarding_Unit FWU(
	.WriteReg_EXMEM_o(WriteReg_EXMEM_o),
	.WriteReg_MEMWB_o(WriteReg_EXMEM_o),
	.RegWrite_MEM(RegWrite_MEM),
	.RegWrite_WB(RegWrite_WB),
	.RSaddr_IDEX_o(RSaddr_IDEX_o),
	.RTaddr_IDEX_o(RTaddr_IDEX_o),
	.Src1_Forward_select_o(Src1_Forward_select_o),
	.Src2_Forward_select_o(Src2_Forward_select_o)
	);
//Second MUX, for operand 1 Forwaring
MUX_4to1 #(.size(32)) Mux_Opd_1_select(
	.data0_i(RSdata_IDEX_o),
	.data1_i(ALU_result_EXMEM_o),
	.data2_i(ALU_result_MEMWB_o),
	.data3_i(32'd0),
	.select_i(Src1_Forward_select_o),
	.data_o(opd_1_o)
	);
//Third MUX, for operand 2 Forwaring
MUX_4to1 #(.size(32)) Mux_Opd_2_select(
	.data0_i(RTdata_IDEX_o),
	.data1_i(ALU_result_EXMEM_o),
	.data2_i(ALU_result_MEMWB_o),
	.data3_i(32'd0),
	.select_i(Src2_Forward_select_o),
	.data_o(opd_2_o)
	);
//Forth MUX, for selecting ALU_src_1
MUX_2to1 #(.size(32)) Mux_ALUSrc_1(
	.data0_i(opd_1_o/*RSdata_IDEX_o*/),
	.data1_i(shamt_IDEX_o),
	.select_i(ALUSrc_1_select_o),
	.data_o(ALU_src_1)
	);
//Fifth MUX, for selecting ALU_src_2
MUX_2to1 #(.size(32)) Mux_ALUSrc_2(
	.data0_i(opd_2_o/*RTdata_IDEX_o*/),
	.data1_i(SE_data_IDEX_o),
	.select_i(ALUSrc_2_select_EX),
	.data_o(ALU_src_2)
	);
//Sixth MUX, for selecting Reg_dst
MUX_4to1 #(.size(5)) Mux_RegDst_Select(
	.data0_i(RTaddr_IDEX_o),
	.data1_i(RDaddr_2_IDEX_o),
	.data2_i(5'd31),
	.data3_i(5'd0),
	.select_i(RegDst_EX),
	.data_o(WriteReg)
	);
ALU ALU(
	.rst(rst_i),
	.src1_i(ALU_src_1),
	.src2_i(ALU_src_2),
	.ctrl_i(ALUCtrl_o),
	.result_o(result_o),
	.zero_o(zero_o)
	);
Shift_Left_Two_32 SLL(
	.data_i(SE_data_IDEX_o),
	.data_o(SLL_data_o)
	);
Adder Adder_For_BranchTarget(
	.src1_i(pc_plus_four_IDEX_o),
	.src2_i(SLL_data_o),
	.sum_o(Branch_target_o)
	);
Pipe_Reg #(.size(142)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({control_EXMEM_i, Branch_target_o, zero_o, result_o,RTdata_IDEX_o, WriteReg, SE_data_IDEX_o}),
	.Pipe_Reg_Write_i(1'b1),
	.data_o({control_EXMEM_o, Branch_target_EXMEM_o, zero_EXMEM_o, ALU_result_EXMEM_o, RTdata_EXMEM_o, WriteReg_EXMEM_o, SE_data_EXMEM_o})
	);

//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ALU_result_EXMEM_o),
	.data_i(RTdata_EXMEM_o),
	.MemRead_i(MemRead_MEM),
	.MemWrite_i(MemWrite_MEM),
	.data_o(MEM_Read_data_o)
	);
//Seventh MUX, for selecting the right branch type
MUX_4to1 #(.size(1)) Mux_Branch_Type(
	.data0_i(zero_EXMEM_o),
	.data1_i(zero_EXMEM_o|ALU_result_EXMEM_o[31]),
	.data2_i(ALU_result_EXMEM_o[31]),
	.data3_i(~zero_EXMEM_o),
	.select_i(BranchType_MEM),
	.data_o(type_branch_o)
	);

Pipe_Reg #(.size(104)) MEM_WB(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({control_MEMWB_i, MEM_Read_data_o, ALU_result_EXMEM_o, WriteReg_EXMEM_o, SE_data_EXMEM_o}),
	.Pipe_Reg_Write_i(1'b1),
	.data_o({control_MEMWB_o, MEM_Read_data_MEMWB_o, ALU_result_MEMWB_o, WriteReg_MEMWB_o, SE_data_MEMWB_o})
	);

//Instantiate the components in WB stage
MUX_4to1 #(.size(32)) Mux_WriteData_Select(
	.data0_i(ALU_result_MEMWB_o),
	.data1_i(MEM_Read_data_MEMWB_o),
	.data2_i(SE_data_MEMWB_o),
	.data3_i(32'd0),
	.select_i(MemToReg_WB),
	.data_o(WriteData_o)
	);

/****************************************
signal assignment
****************************************/
endmodule
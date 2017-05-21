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
	/*----For Reg_File Module----*/
	wire [32-1:0] RSdata_o;
	wire [32-1:0] RTdata_o;
	/*###########################*/
	/*----For Sign_Extend Module Module----*/
	wire [32-1:0] SE_data_o;
	/*#####################################*/
	wire [32-1:0] shamt;
	assign shamt = {27'b0,IFID_o[10:6]};
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
	//wire  RegDst_o;
	wire [2-1:0] RegDst_o;
	//wire Jump_type;//MUX right is not used this time
	/*##########################*/
	wire [14-1:0] control_total;
	assign control_total = {Branch_o,MemToReg_o,BranchType_o,MemRead_o,MemWrite_o,
	ALU_op_o,ALUSrc_2_select_o,RegWrite_o,RegDst_o};
/**** ID stage End****/
/*------For ID/EX Reg out------*/
	wire [14-1:0] control_IDEX_o;
	wire [32-1:0] pc_plus_four_IDEX_o;
	wire [32-1:0] shamt_IDEX_o;
	wire [32-1:0] RSdata_o_IDEX_o;
	wire [32-1:0] RTdata_o_IDEX_o;
	wire [32-1:0] SE_data_o_IDEX_o;
	wire [5-1:0] RDaddr_1_o_IDEX_o;
	wire [5-1:0] RDaddr_2_o_IDEX_o;
/*#############################*/
/**** EX stage ****/
	/*For ALU Module*/
	wire [32-1:0] ALU_src_1;
	wire [32-1:0] ALU_src_2;
	wire [32-1:0] result_o;
	wire zero;
	/*#############*/
	wire [5-1:0] WriteReg;
//control signal
	/*For ALU_Ctrl Module*/
	wire ALUSrc_1_select_o;
	wire [4-1:0] ALUCtrl_o;
	/*#############*/
/**** EX stage End****/
/**** MEM stage ****/

//control signal


/**** WB stage ****/

//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 PC_num_MUX(
	data0_i(),
	data1_i(),
	select_i(),
	data_o()
	);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc_number_in),
	//.pc_in_i(pc_number_next),
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
	.data_o(IFID_o)
	);

//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(IFID_o[25:21]),
	.RTaddr_i(IFID_o[20:16]),
	.RDaddr_i(),//Come from MEM/WB reg
	.RDdata_i(),//Come from the MUX in MEM/WB stage
	.RegWrite_i(),//Come from MEM/WB reg
	.RSdata_o(RSdata_o),
	.RTdata_o(RTdata_o)
	);

Decoder Control(
	.instr_op_i(IFID_o[31:26]),
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
	.data_i(IFID_o[16-1:0]),
	.data_o(SE_data_o)
	);

Pipe_Reg #(.size(184)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({control_total,IFID_o[63:32],shamt,RSdata_o,RTdata_o,SE_data_o,IFID_o[20:16],IFID_o[15:11]}),
	.data_o({control_IDEX_o,pc_plus_four_IDEX_o,RSdata_o_IDEX_o,RTdata_o_IDEX_o,SE_data_o_IDEX_o,RDaddr_1_o_IDEX_o,RDaddr_2_o_IDEX_o})
	);

//Instantiate the components in EX stage
ALU_Ctrl ALU_Ctrl(
	.funct_i(SE_data_o_IDEX_o[6-1:0]),
	.ALUOp_i(ALU_op_o),
	.ALUCtrl_o(ALUCtrl_o),
	.ALUSrc_1_o(ALUSrc_1_select_o)
	//.Jump_type(Jump_type)
	);

ALU ALU(
	.rst(rst_i),
	.src1_i(ALU_src_1),
	.src2_i(ALU_src_2),
	.ctrl_i(ALUCtrl_o),
	.result_o(result_o),
	.zero_o(zero_o),
	);

MUX_2to1 #(.size(32)) Mux_ALUSrc_1(
	.data0_i(RSdata_o_IDEX_o),
	.data1_i(shamt_IDEX_o),
	.select_i(ALUSrc_1_select_o),
	.data_o(ALU_src_1)
	);

MUX_2to1 #(.size(32)) Mux_ALUSrc_2(
	.data0_i(RTdata_o_IDEX_o),
	.data1_i(SE_data_o_IDEX_o),
	.select_i(ALUSrc_2_select_o),
	.data_o(ALU_src_2)
	);

MUX_4to1 #(.size(5)) Mux3(
	.data0_i(RDaddr_1_o_IDEX_o),
	.data1_i(RDaddr_2_o_IDEX_o),
	.data2_i(5'd0),
	.data3_i(5'd0),
	.select_i(control_IDEX_o[2-1:0]),
	.data_o(WriteReg)
	);

Pipe_Reg #(.size(N)) EX_MEM(

		);

//Instantiate the components in MEM stage
Data_Memory DM(

	    );

Pipe_Reg #(.size(N)) MEM_WB(

		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux4(

        );

/****************************************
signal assignment
****************************************/
endmodule


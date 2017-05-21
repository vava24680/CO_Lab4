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

/*For PC Module*/
wire [32-1:0] pc_number;
wire [32-1:0] pc_number_next;
wire [32-1:0] pc_number_in;
wire [32-1:0] pc_plus_four;


/**** IF stage ****/


/**** ID stage ****/

//control signal


/**** EX stage ****/

//control signal


/**** MEM stage ****/

//control signal


/**** WB stage ****/

//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 Mux1(

		);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc_number_in),
	//.pc_in_i(pc_number_next),
	.pc_out_o(pc_number)
        );

Instr_Memory IM(

	    );

Adder Add_pc(

		);

		
Pipe_Reg #(.size(N)) IF_ID(       //N is the total length of input/output

		);

//Instantiate the components in ID stage
Reg_File RF(

		);

Decoder Control(

		);

Sign_Extend Sign_Extend(

		);	

Pipe_Reg #(.size(N)) ID_EX(

		);

//Instantiate the components in EX stage	   
ALU ALU(

		);

ALU_Ctrl ALU_Ctrl(

		);

MUX_2to1 #(.size(32)) Mux2(

        );

MUX_2to1 #(.size(5)) Mux3(

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


//Subject:     CO project 2 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315�� 0416005張彧��//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
	rst_i,
	pc_in_i,
	PCWrite_i,
	pc_out_o
	//pc_next
	);

//I/O ports
input           clk_i;
input	        rst_i;
input  [32-1:0] pc_in_i;
input PCWrite_i;
//output [32-1:0] pc_next;
output [32-1:0] pc_out_o;

//Internal Signals
reg    [32-1:0] pc_out_o;

//Parameter
wire [32-1:0] Original_PC;
//assign Original_PC = pc_in_i-32'd4;
Adder subtract(
	.src1_i(pc_in_i),
	.src2_i(-32'd4),
	.sum_o(Original_PC)
	);


//assign pc_next = PCWrite_i ? pc_out_o : Original_PC;

//Main function
always @(posedge clk_i) begin
    if(~rst_i)
	    pc_out_o <= 0;
	else
		if(PCWrite_i)
			begin
				pc_out_o <= pc_in_i;
			end
		else
			begin
				pc_out_o <= pc_out_o;
			end
end

endmodule





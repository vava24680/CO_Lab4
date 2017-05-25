//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
	rst_i,
	data_i,
	Pipe_Reg_Write_i,
	data_o
	);

parameter size = 0;

input					clk_i;
input					rst_i;
input		[size-1: 0]	data_i;
input Pipe_Reg_Write_i;
output reg	[size-1: 0]	data_o;

always @(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else
		if(Pipe_Reg_Write_i)
			begin
				data_o <= data_i;
			end
		else
			begin
				data_o <= data_o;
			end
end

endmodule
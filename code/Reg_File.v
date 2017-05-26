//Subject:     CO project 2 - Register File
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315�� 0416005張彧��//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Reg_File(
    clk_i,
	rst_i,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i,
    RDdata_i,
    RegWrite_i,
    RSdata_o,
    RTdata_o,
	pre_equal_o
    );

//I/O ports
input           clk_i;
input           rst_i;
input           RegWrite_i;
input  [5-1:0]  RSaddr_i;
input  [5-1:0]  RTaddr_i;
input  [5-1:0]  RDaddr_i;
input  [32-1:0] RDdata_i;
input pre_equal_o;
output [32-1:0] RSdata_o;
output [32-1:0] RTdata_o;

//Internal signals/registers
reg  signed [32-1:0] Reg_File [0:32-1];     //32 word registers
wire        [32-1:0] RSdata_o;
wire        [32-1:0] RTdata_o;

//Read the data
/*Must do this*/
/*
Since if in one clock if we want to fetch some reg_file which is going to be writen a new value,
the new value isn't set well until new clock edge, so the old syntax will fetch the old value in that reg_file.
The meaning of new syntax is that if we want to fetch some reg_file which is going to be writen a new value in
, we just assign the output data as the the new value which is going to be writen in a reg_file in thie cycle.
*/
//assign RSdata_o = Reg_File[RSaddr_i] ;
assign RSdata_o = ((RSaddr_i==RDaddr_i) && RegWrite_i) ? RDdata_i : Reg_File[RSaddr_i];
//assign RTdata_o = Reg_File[RTaddr_i] ;
assign RTdata_o = ((RTaddr_i==RDaddr_i) && RegWrite_i) ? RDdata_i : Reg_File[RTaddr_i];/*-*/
/*----------------------------------------------------------------------*/
assign pre_equal_o = (RSdata_o==RTdata_o) ? 1'b1 : 1'b0;


//Writing data when postive edge clk_i and RegWrite_i was set.
always @( posedge rst_i or posedge clk_i  ) begin
    if(rst_i == 0) begin
	    Reg_File[0]  <= 0; Reg_File[1]  <= 0; Reg_File[2]  <= 0; Reg_File[3]  <= 0;
	    Reg_File[4]  <= 0; Reg_File[5]  <= 0; Reg_File[6]  <= 0; Reg_File[7]  <= 0;
        Reg_File[8]  <= 0; Reg_File[9]  <= 0; Reg_File[10] <= 0; Reg_File[11] <= 0;
	    Reg_File[12] <= 0; Reg_File[13] <= 0; Reg_File[14] <= 0; Reg_File[15] <= 0;
        Reg_File[16] <= 0; Reg_File[17] <= 0; Reg_File[18] <= 0; Reg_File[19] <= 0;
        Reg_File[20] <= 0; Reg_File[21] <= 0; Reg_File[22] <= 0; Reg_File[23] <= 0;
        Reg_File[24] <= 0; Reg_File[25] <= 0; Reg_File[26] <= 0; Reg_File[27] <= 0;
        Reg_File[28] <= 0; Reg_File[29] <= 0; Reg_File[30] <= 0; Reg_File[31] <= 0;
	end
    else
	begin
        if(RegWrite_i)
			if(RDaddr_i!=32'd0)
            	Reg_File[RDaddr_i] <= RDdata_i;
			else
				Reg_File[RDaddr_i] <= 32'b0;
		else
		    Reg_File[RDaddr_i] <= Reg_File[RDaddr_i];
	end
end

endmodule







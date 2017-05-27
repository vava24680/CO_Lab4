module Hazard_Detection_Unit(
	PCSrc_select_i,
	MemRead_EX_i,
	RSaddr_IFID_i,
	RTaddr_IFID_i,
	RTaddr_IDEX_i,
	PCWrite_o,
	Flush_IFID_o,
	WritePipeReg_IFID_o,
	ControlReset_ID_o,
	ControlReset_EX_o
	);
input PCSrc_select_i;
input MemRead_EX_i;
input [5-1:0] RSaddr_IFID_i;
input [5-1:0] RTaddr_IFID_i;
input [5-1:0] RTaddr_IDEX_i;
output PCWrite_o;
output Flush_IFID_o;
output WritePipeReg_IFID_o;
output ControlReset_ID_o;
output ControlReset_EX_o;
reg PCWrite_o;
reg Flush_IFID_o;
reg WritePipeReg_IFID_o;
reg ControlReset_ID_o;
reg ControlReset_EX_o;

always @ ( * ) begin
	if(MemRead_EX_i && (RSaddr_IFID_i==RTaddr_IDEX_i || RTaddr_IFID_i==RTaddr_IDEX_i) )
	//For Load-Use Data Hazard. Only reset control in ID stage.
		begin
			PCWrite_o = 1'b0;
			WritePipeReg_IFID_o = 1'b0;
			Flush_IFID_o = 1'b0;
			ControlReset_ID_o = 1'b1;
			ControlReset_EX_o = 1'b0;
		end
	else
		begin
			PCWrite_o = 1'b1;
			WritePipeReg_IFID_o = 1'b1;
			Flush_IFID_o = 1'b0;
			ControlReset_ID_o = 1'b0;
			ControlReset_EX_o = 1'b0;
		end
end
endmodule
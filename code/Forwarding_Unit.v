module Forwarding_Unit(
	WriteReg_EXMEM_o,
	WriteReg_MEMWB_o,
	RegWrite_MEM,
	RegWrite_WB,
	RSaddr_IDEX_o,
	RTaddr_IDEX_o,
	Src1_Forward_select_o,
	Src2_Forward_select_o
	);
input [5-1:0] WriteReg_EXMEM_o;
input [5-1:0] WriteReg_MEMWB_o;
input RegWrite_MEM;
input RegWrite_WB;
input [5-1:0] RSaddr_IDEX_o;
input [5-1:0] RTaddr_IDEX_o;

output [2-1:0] Src1_Forward_select_o;
output [2-1:0] Src2_Forward_select_o;

reg [2-1:0] Src1_Forward_select_o;
reg [2-1:0] Src2_Forward_select_o;

/*Src1_Forward_select_o and Src2_Forward_select_o signal corresponding to choose which operand source;
---------------------------------
Src1, Src2, operand source           -
    00    ,   Original               -
    01    ,   result from EX/MEM reg -
    10    ,   result from MEM/WB reg -
	11    ,   Further use            -
--------------------------------------
*/

always @ ( * ) begin
	//Case1, WriteReg_EXMEM_o has data dependency with RSaddr_IDEX_o
	/*if(WriteReg_EXMEM_o==RSaddr_IDEX_o)
		begin
			if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
				begin
					Src1_Forward_select_o = 2'b01;
				end
			else
				begin
					Src1_Forward_select_o = 2'b00;
				end
		end
	else if(
			(RegWrite_WB && WriteReg_MEMWB_o!=5'd0) && (WriteReg_MEMWB_o==RSaddr_IDEX_o)
			&&
			!(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0 && WriteReg_EXMEM_o==RSaddr_IDEX_o)
			)
		begin
			Src1_Forward_select_o = 2'b10;
		end
	else
		begin
			Src1_Forward_select_o = 2'b00;
		end*/
	if(WriteReg_EXMEM_o==RSaddr_IDEX_o || WriteReg_MEMWB_o==RSaddr_IDEX_o)
		begin
			if(WriteReg_EXMEM_o==RSaddr_IDEX_o && WriteReg_MEMWB_o==RSaddr_IDEX_o)
				begin
					if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
						begin
							Src1_Forward_select_o = 2'b01;
						end
					else if(RegWrite_WB && WriteReg_MEMWB_o!=5'd0)
						begin
							Src1_Forward_select_o = 2'b10;
						end
					else
						begin
							Src1_Forward_select_o = 2'b00;
						end
				end
			else if(WriteReg_EXMEM_o==RSaddr_IDEX_o)
				begin
					if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
						begin
							Src1_Forward_select_o = 2'b01;
						end
					else
						begin
							Src1_Forward_select_o = 2'b00;
						end
				end
			else
				begin
					if(RegWrite_WB && WriteReg_MEMWB_o!=5'd0)
						begin
							Src1_Forward_select_o = 2'b10;
						end
					else
						begin
							Src1_Forward_select_o = 2'b00;
						end
				end
		end
	else
		begin
			Src1_Forward_select_o = 2'b00;
		end

	if(WriteReg_EXMEM_o==RTaddr_IDEX_o || WriteReg_MEMWB_o==RTaddr_IDEX_o)
		begin
			if(WriteReg_EXMEM_o==RTaddr_IDEX_o && WriteReg_MEMWB_o==RTaddr_IDEX_o)
				begin
					if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
						begin
							Src2_Forward_select_o = 2'b01;
						end
					else if(RegWrite_WB && WriteReg_MEMWB_o!=5'd0)
						begin
							Src2_Forward_select_o = 2'b10;
						end
					else
						begin
							Src2_Forward_select_o = 2'b00;
						end
				end
			else if(WriteReg_EXMEM_o==RTaddr_IDEX_o)
				begin
					if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
						begin
							Src2_Forward_select_o = 2'b01;
						end
					else
						begin
							Src2_Forward_select_o = 2'b00;
						end
				end
			else
				begin
					if(RegWrite_WB && WriteReg_MEMWB_o!=5'd0)
						begin
							Src2_Forward_select_o = 2'b10;
						end
					else
						begin
							Src2_Forward_select_o = 2'b00;
						end
				end
		end
	else
		begin
			Src2_Forward_select_o = 2'b00;
		end
	/*if(WriteReg_EXMEM_o==RTaddr_IDEX_o)
		begin
			if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
				begin
					Src2_Forward_select_o = 2'b01;
				end
			else
				begin
					Src2_Forward_select_o = 2'b00;
				end
		end
	else if(
			(RegWrite_WB && WriteReg_MEMWB_o!=5'd0) && (WriteReg_MEMWB_o==RTaddr_IDEX_o)
			&&
			!(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0 && WriteReg_EXMEM_o==RTaddr_IDEX_o)
		)
		begin
			Src2_Forward_select_o = 2'b10;
		end
	else
		begin
			Src2_Forward_select_o = 2'b00;
		end*/

	/*if(WriteReg_EXMEM_o==RSaddr_IDEX_o)
		begin
			if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
				begin
					Src1_Forward_select_o = 2'b01;
				end
			else
				begin
					Src1_Forward_select_o = 2'b00;
				end
		end
	else
		begin
			Src1_Forward_select_o = 2'b00;
		end

	//Case2, WriteReg_EXMEM_o has data dependency with RTaddr_IDEX_o
	if(WriteReg_EXMEM_o==RTaddr_IDEX_o)
		begin
			if(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0)
				begin
					Src2_Forward_select_o = 2'b01;
				end
			else
				begin
					Src2_Forward_select_o = 2'b00;
				end
		end
	else
		begin
			Src2_Forward_select_o = 2'b00;
		end

	//Case3, WriteReg_MEMWB_o has data dependency with RSaddr_IDEX_o
	if(
		(RegWrite_WB && WriteReg_MEMWB_o!=5'd0) && (WriteReg_MEMWB_o==RSaddr_IDEX_o)
		&&
		!(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0 && WriteReg_EXMEM_o==RSaddr_IDEX_o)
	)
		Src1_Forward_select_o = 2'b10;
	else
		Src1_Forward_select_o = 2'b00;

	//Case4, WriteReg_MEMWB_o has data dependency with RTaddr_IDEX_o
	if(
		(RegWrite_WB && WriteReg_MEMWB_o!=5'd0) && (WriteReg_MEMWB_o==RTaddr_IDEX_o)
		&&
		!(RegWrite_MEM && WriteReg_EXMEM_o!=5'd0 && WriteReg_EXMEM_o==RTaddr_IDEX_o)
	)
		Src2_Forward_select_o = 2'b10;
	else
		Src2_Forward_select_o = 2'b00;*/
end
endmodule
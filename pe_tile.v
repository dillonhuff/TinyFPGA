`include "clb.v"
`include "connect_box.v"
`include "switch_box.v"


module pe_tile(
	input clk,
	input reset,
	input [31:0] config_addr,
	input [31:0] config_data,
	input [15:0] tile_id,
	input in_wire_0_0,
	input in_wire_0_1,
	input in_wire_0_2,
	input in_wire_0_3,
	input in_wire_1_0,
	input in_wire_1_1,
	input in_wire_1_2,
	input in_wire_1_3,
	input in_wire_2_0,
	input in_wire_2_1,
	input in_wire_2_2,
	input in_wire_2_3,
	input in_wire_3_0,
	input in_wire_3_1,
	input in_wire_3_2,
	input in_wire_3_3,
	output out_wire_0_0,
	output out_wire_0_1,
	output out_wire_0_2,
	output out_wire_0_3,
	output out_wire_1_0,
	output out_wire_1_1,
	output out_wire_1_2,
	output out_wire_1_3,
	output out_wire_2_0,
	output out_wire_2_1,
	output out_wire_2_2,
	output out_wire_2_3,
	output out_wire_3_0,
	output out_wire_3_1,
	output out_wire_3_2,
	output out_wire_3_3
	);



endmodule
`ifndef pe_tile_included
`define pe_tile_included 1
`include "pe_tile"
`endif

`ifndef io1in_pad_included
`define io1in_pad_included 1
`include "io1in_pad"
`endif

`ifndef io1out_pad_included
`define io1out_pad_included 1
`include "io1out_pad"
`endif



module top(
	input clk,
	input reset,
	input [31:0] config_addr,
	input [31:0] config_data,
	input in_wire_0,
	input in_wire_1,
	input in_wire_2,
	output out_wire_0,
	output out_wire_1,
	output out_wire_2
	);

	// Internal wires
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_2;
	wire [1 - 1 : 0] in_pad_2_pin_to_pe_tile_0_2_in_wire_3_0;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_0_0_const;
	wire [1 - 1 : 0] pe_tile_2_0_in_wire_1_1_const;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_1;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_0;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_3;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_2;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_0_1_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_1_0_const;
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_1;
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_0;
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_3;
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_2;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_1;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_0;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_3;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_2;
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_3_const;
	wire [1 - 1 : 0] pe_tile_2_0_in_wire_1_3_const;
	wire [1 - 1 : 0] pe_tile_0_0in_wire_2_1_const;
	wire [1 - 1 : 0] pe_tile_1_2_in_wire_0_1_const;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_3;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_2;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_1;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_0;
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_3_const;
	wire [1 - 1 : 0] out_pad_0_pin_to_pe_tile_2_0_out_wire_1_0;
	wire [16 - 1 : 0] pe_tile_0_2_id_wire;
	wire [1 - 1 : 0] pe_tile_1_0in_wire_2_0_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_0_3_const;
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_1;
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_0;
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_3;
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_2;
	wire [1 - 1 : 0] pe_tile_2_1_in_wire_1_2_const;
	wire [1 - 1 : 0] pe_tile_1_2_in_wire_0_2_const;
	wire [1 - 1 : 0] pe_tile_1_0in_wire_2_3_const;
	wire [16 - 1 : 0] pe_tile_0_1_id_wire;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_1;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_0;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_3;
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_2;
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_3;
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_2;
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_1;
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_0;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_0_1_const;
	wire [16 - 1 : 0] pe_tile_0_0_id_wire;
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_1;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_0;
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_3;
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_2;
	wire [1 - 1 : 0] pe_tile_2_1_in_wire_1_3_const;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_3;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_2;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_1;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_0;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_1;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_0;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_3;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_2;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_2_const;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_1_const;
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_3;
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_2;
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_1;
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_0;
	wire [16 - 1 : 0] pe_tile_2_0_id_wire;
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_1_const;
	wire [1 - 1 : 0] in_pad_1_pin_to_pe_tile_0_1_in_wire_3_0;
	wire [1 - 1 : 0] pe_tile_2_0_in_wire_1_2_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_0_0_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_1_1_const;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_3;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_2;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_1;
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_0;
	wire [1 - 1 : 0] pe_tile_2_1_in_wire_1_1_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_1_3_const;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_0_3_const;
	wire [1 - 1 : 0] pe_tile_2_0_in_wire_1_0_const;
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_2_const;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_1_2_const;
	wire [1 - 1 : 0] pe_tile_1_2_in_wire_0_0_const;
	wire [1 - 1 : 0] pe_tile_2_0in_wire_2_1_const;
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_1_const;
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_3;
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_2;
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_1;
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_0;
	wire [1 - 1 : 0] pe_tile_1_2_in_wire_0_3_const;
	wire [16 - 1 : 0] pe_tile_1_1_id_wire;
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_3;
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_2;
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_1;
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_2;
	wire [16 - 1 : 0] pe_tile_2_2_id_wire;
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_1;
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_0;
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_3;
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_2;
	wire [16 - 1 : 0] pe_tile_2_1_id_wire;
	wire [1 - 1 : 0] pe_tile_0_0in_wire_2_0_const;
	wire [1 - 1 : 0] pe_tile_2_1_in_wire_1_0_const;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_0;
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_3;
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_2;
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_1;
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_0;
	wire [1 - 1 : 0] pe_tile_1_0in_wire_2_2_const;
	wire [1 - 1 : 0] in_pad_0_pin_to_pe_tile_0_0_in_wire_3_0;
	wire [1 - 1 : 0] pe_tile_2_0in_wire_2_0_const;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_3_const;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_3;
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_0_2_const;
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_2_const;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_2;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_1;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_0;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_3;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_2;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_1;
	wire [1 - 1 : 0] out_pad_1_pin_to_pe_tile_2_1_out_wire_1_0;
	wire [1 - 1 : 0] pe_tile_0_0in_wire_2_3_const;
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_0;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_3;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_2;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_1;
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_0;
	wire [1 - 1 : 0] pe_tile_2_2_in_wire_0_2_const;
	wire [1 - 1 : 0] pe_tile_2_0in_wire_2_2_const;
	wire [1 - 1 : 0] out_pad_2_pin_to_pe_tile_2_2_out_wire_1_0;
	wire [1 - 1 : 0] pe_tile_2_0in_wire_2_3_const;
	wire [1 - 1 : 0] pe_tile_0_0in_wire_2_2_const;
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_3;
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_2;
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_1;
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_0;
	wire [16 - 1 : 0] pe_tile_1_0_id_wire;
	wire [16 - 1 : 0] pe_tile_1_2_id_wire;
	wire [1 - 1 : 0] pe_tile_1_0in_wire_2_1_const;
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_1;
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_0;
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_3;
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_2;
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_1;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_3;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_2;
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_1;
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_0;
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_3;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_1;
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_0;
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_0;
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_3;
	// End of internal wires
	io1out_pad out_pad_2(
		.top_pin(out_wire_2),
		.clk(clk),
		.pin(out_pad_2_pin_to_pe_tile_2_2_out_wire_1_0)
	);
	assign_mod assign_pe_tile_1_0in_wire_2_1_const_21(
		.in(pe_tile_1_0in_wire_2_1_const)
	);
	assign_mod assign_pe_tile_2_2_id_wire_53(
		.in(pe_tile_2_2_id_wire)
	);
	assign_mod assign_pe_tile_2_1_id_wire_44(
		.in(pe_tile_2_1_id_wire)
	);
	assign_mod assign_pe_tile_2_2_in_wire_0_0_const_49(
		.in(pe_tile_2_2_in_wire_0_0_const)
	);
	assign_mod assign_pe_tile_0_0_in_wire_3_2_const_1(
		.in(pe_tile_0_0_in_wire_3_2_const)
	);
	assign_mod assign_pe_tile_2_1_in_wire_1_3_const_43(
		.in(pe_tile_2_1_in_wire_1_3_const)
	);
	io1in_pad in_pad_2(
		.clk(clk),
		.top_pin(in_wire_2),
		.pin(in_pad_2_pin_to_pe_tile_0_2_in_wire_3_0)
	);
	assign_mod assign_pe_tile_1_2_in_wire_0_3_const_29(
		.in(pe_tile_1_2_in_wire_0_3_const)
	);
	assign_mod assign_pe_tile_2_0_in_wire_1_1_const_32(
		.in(pe_tile_2_0_in_wire_1_1_const)
	);
	assign_mod assign_pe_tile_1_0in_wire_2_0_const_20(
		.in(pe_tile_1_0in_wire_2_0_const)
	);
	assign_mod assign_pe_tile_0_2_in_wire_3_3_const_14(
		.in(pe_tile_0_2_in_wire_3_3_const)
	);
	assign_mod assign_pe_tile_1_2_in_wire_0_1_const_27(
		.in(pe_tile_1_2_in_wire_0_1_const)
	);
	assign_mod assign_pe_tile_2_1_in_wire_1_2_const_42(
		.in(pe_tile_2_1_in_wire_1_2_const)
	);
	io1out_pad out_pad_1(
		.top_pin(out_wire_1),
		.clk(clk),
		.pin(out_pad_1_pin_to_pe_tile_2_1_out_wire_1_0)
	);
	assign_mod assign_pe_tile_2_0in_wire_2_3_const_38(
		.in(pe_tile_2_0in_wire_2_3_const)
	);
	assign_mod assign_pe_tile_0_2_in_wire_3_2_const_13(
		.in(pe_tile_0_2_in_wire_3_2_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_0_2_const_51(
		.in(pe_tile_2_2_in_wire_0_2_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_1_0_const_45(
		.in(pe_tile_2_2_in_wire_1_0_const)
	);
	assign_mod assign_pe_tile_1_2_in_wire_0_2_const_28(
		.in(pe_tile_1_2_in_wire_0_2_const)
	);
	io1in_pad in_pad_1(
		.clk(clk),
		.top_pin(in_wire_1),
		.pin(in_pad_1_pin_to_pe_tile_0_1_in_wire_3_0)
	);
	assign_mod assign_pe_tile_1_1_id_wire_25(
		.in(pe_tile_1_1_id_wire)
	);
	assign_mod assign_pe_tile_1_0in_wire_2_3_const_23(
		.in(pe_tile_1_0in_wire_2_3_const)
	);
	assign_mod assign_pe_tile_0_0in_wire_2_0_const_3(
		.in(pe_tile_0_0in_wire_2_0_const)
	);
	assign_mod assign_pe_tile_0_0_in_wire_3_1_const_0(
		.in(pe_tile_0_0_in_wire_3_1_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_1_3_const_48(
		.in(pe_tile_2_2_in_wire_1_3_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_0_3_const_52(
		.in(pe_tile_2_2_in_wire_0_3_const)
	);
	pe_tile_bottom pe_tile_2_1(
		.out_wire_3_0(vertical_tile_2_1_to_tile_1_1_0),
		.out_wire_3_1(vertical_tile_2_1_to_tile_1_1_1),
		.out_wire_3_2(vertical_tile_2_1_to_tile_1_1_2),
		.out_wire_3_3(vertical_tile_2_1_to_tile_1_1_3),
		.in_wire_3_0(vertical_tile_1_1_to_tile_2_1_0),
		.in_wire_3_1(vertical_tile_1_1_to_tile_2_1_1),
		.in_wire_3_2(vertical_tile_1_1_to_tile_2_1_2),
		.in_wire_3_3(vertical_tile_1_1_to_tile_2_1_3),
		.out_wire_1_0(out_pad_1_pin_to_pe_tile_2_1_out_wire_1_0),
		.in_wire_1_0(pe_tile_2_1_in_wire_1_0_const),
		.in_wire_1_1(pe_tile_2_1_in_wire_1_1_const),
		.in_wire_1_2(pe_tile_2_1_in_wire_1_2_const),
		.in_wire_1_3(pe_tile_2_1_in_wire_1_3_const),
		.out_wire_2_0(horizontal_tile_2_1_to_tile_2_0_0),
		.out_wire_2_1(horizontal_tile_2_1_to_tile_2_0_1),
		.out_wire_2_2(horizontal_tile_2_1_to_tile_2_0_2),
		.out_wire_2_3(horizontal_tile_2_1_to_tile_2_0_3),
		.in_wire_2_0(horizontal_tile_2_0_to_tile_2_1_0),
		.in_wire_2_1(horizontal_tile_2_0_to_tile_2_1_1),
		.in_wire_2_2(horizontal_tile_2_0_to_tile_2_1_2),
		.in_wire_2_3(horizontal_tile_2_0_to_tile_2_1_3),
		.out_wire_0_0(horizontal_tile_2_1_to_tile_2_2_0),
		.out_wire_0_1(horizontal_tile_2_1_to_tile_2_2_1),
		.out_wire_0_2(horizontal_tile_2_1_to_tile_2_2_2),
		.out_wire_0_3(horizontal_tile_2_1_to_tile_2_2_3),
		.in_wire_0_0(horizontal_tile_2_2_to_tile_2_1_0),
		.in_wire_0_1(horizontal_tile_2_2_to_tile_2_1_1),
		.in_wire_0_2(horizontal_tile_2_2_to_tile_2_1_2),
		.in_wire_0_3(horizontal_tile_2_2_to_tile_2_1_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_1_id_wire)
	);
	pe_tile_left pe_tile_1_0(
		.out_wire_3_0(vertical_tile_1_0_to_tile_0_0_0),
		.out_wire_3_1(vertical_tile_1_0_to_tile_0_0_1),
		.out_wire_3_2(vertical_tile_1_0_to_tile_0_0_2),
		.out_wire_3_3(vertical_tile_1_0_to_tile_0_0_3),
		.in_wire_3_0(vertical_tile_0_0_to_tile_1_0_0),
		.in_wire_3_1(vertical_tile_0_0_to_tile_1_0_1),
		.in_wire_3_2(vertical_tile_0_0_to_tile_1_0_2),
		.in_wire_3_3(vertical_tile_0_0_to_tile_1_0_3),
		.out_wire_1_0(vertical_tile_1_0_to_tile_2_0_0),
		.out_wire_1_1(vertical_tile_1_0_to_tile_2_0_1),
		.out_wire_1_2(vertical_tile_1_0_to_tile_2_0_2),
		.out_wire_1_3(vertical_tile_1_0_to_tile_2_0_3),
		.in_wire_1_0(vertical_tile_2_0_to_tile_1_0_0),
		.in_wire_1_1(vertical_tile_2_0_to_tile_1_0_1),
		.in_wire_1_2(vertical_tile_2_0_to_tile_1_0_2),
		.in_wire_1_3(vertical_tile_2_0_to_tile_1_0_3),
		.in_wire_2_0(pe_tile_1_0in_wire_2_0_const),
		.in_wire_2_1(pe_tile_1_0in_wire_2_1_const),
		.in_wire_2_2(pe_tile_1_0in_wire_2_2_const),
		.in_wire_2_3(pe_tile_1_0in_wire_2_3_const),
		.out_wire_0_0(horizontal_tile_1_0_to_tile_1_1_0),
		.out_wire_0_1(horizontal_tile_1_0_to_tile_1_1_1),
		.out_wire_0_2(horizontal_tile_1_0_to_tile_1_1_2),
		.out_wire_0_3(horizontal_tile_1_0_to_tile_1_1_3),
		.in_wire_0_0(horizontal_tile_1_1_to_tile_1_0_0),
		.in_wire_0_1(horizontal_tile_1_1_to_tile_1_0_1),
		.in_wire_0_2(horizontal_tile_1_1_to_tile_1_0_2),
		.in_wire_0_3(horizontal_tile_1_1_to_tile_1_0_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_0_id_wire)
	);
	io1out_pad out_pad_0(
		.top_pin(out_wire_0),
		.clk(clk),
		.pin(out_pad_0_pin_to_pe_tile_2_0_out_wire_1_0)
	);
	assign_mod assign_pe_tile_0_1_in_wire_3_1_const_8(
		.in(pe_tile_0_1_in_wire_3_1_const)
	);
	assign_mod assign_pe_tile_0_0in_wire_2_1_const_4(
		.in(pe_tile_0_0in_wire_2_1_const)
	);
	assign_mod assign_pe_tile_1_0in_wire_2_2_const_22(
		.in(pe_tile_1_0in_wire_2_2_const)
	);
	assign_mod assign_pe_tile_0_0_in_wire_3_3_const_2(
		.in(pe_tile_0_0_in_wire_3_3_const)
	);
	assign_mod assign_pe_tile_0_2_in_wire_0_1_const_16(
		.in(pe_tile_0_2_in_wire_0_1_const)
	);
	assign_mod assign_pe_tile_0_2_in_wire_0_2_const_17(
		.in(pe_tile_0_2_in_wire_0_2_const)
	);
	io1in_pad in_pad_0(
		.clk(clk),
		.top_pin(in_wire_0),
		.pin(in_pad_0_pin_to_pe_tile_0_0_in_wire_3_0)
	);
	assign_mod assign_pe_tile_0_2_in_wire_0_3_const_18(
		.in(pe_tile_0_2_in_wire_0_3_const)
	);
	assign_mod assign_pe_tile_1_2_in_wire_0_0_const_26(
		.in(pe_tile_1_2_in_wire_0_0_const)
	);
	pe_tile_right pe_tile_1_2(
		.out_wire_3_0(vertical_tile_1_2_to_tile_0_2_0),
		.out_wire_3_1(vertical_tile_1_2_to_tile_0_2_1),
		.out_wire_3_2(vertical_tile_1_2_to_tile_0_2_2),
		.out_wire_3_3(vertical_tile_1_2_to_tile_0_2_3),
		.in_wire_3_0(vertical_tile_0_2_to_tile_1_2_0),
		.in_wire_3_1(vertical_tile_0_2_to_tile_1_2_1),
		.in_wire_3_2(vertical_tile_0_2_to_tile_1_2_2),
		.in_wire_3_3(vertical_tile_0_2_to_tile_1_2_3),
		.out_wire_1_0(vertical_tile_1_2_to_tile_2_2_0),
		.out_wire_1_1(vertical_tile_1_2_to_tile_2_2_1),
		.out_wire_1_2(vertical_tile_1_2_to_tile_2_2_2),
		.out_wire_1_3(vertical_tile_1_2_to_tile_2_2_3),
		.in_wire_1_0(vertical_tile_2_2_to_tile_1_2_0),
		.in_wire_1_1(vertical_tile_2_2_to_tile_1_2_1),
		.in_wire_1_2(vertical_tile_2_2_to_tile_1_2_2),
		.in_wire_1_3(vertical_tile_2_2_to_tile_1_2_3),
		.out_wire_2_0(horizontal_tile_1_2_to_tile_1_1_0),
		.out_wire_2_1(horizontal_tile_1_2_to_tile_1_1_1),
		.out_wire_2_2(horizontal_tile_1_2_to_tile_1_1_2),
		.out_wire_2_3(horizontal_tile_1_2_to_tile_1_1_3),
		.in_wire_2_0(horizontal_tile_1_1_to_tile_1_2_0),
		.in_wire_2_1(horizontal_tile_1_1_to_tile_1_2_1),
		.in_wire_2_2(horizontal_tile_1_1_to_tile_1_2_2),
		.in_wire_2_3(horizontal_tile_1_1_to_tile_1_2_3),
		.in_wire_0_0(pe_tile_1_2_in_wire_0_0_const),
		.in_wire_0_1(pe_tile_1_2_in_wire_0_1_const),
		.in_wire_0_2(pe_tile_1_2_in_wire_0_2_const),
		.in_wire_0_3(pe_tile_1_2_in_wire_0_3_const),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_2_id_wire)
	);
	assign_mod assign_pe_tile_2_0_in_wire_1_3_const_34(
		.in(pe_tile_2_0_in_wire_1_3_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_1_1_const_46(
		.in(pe_tile_2_2_in_wire_1_1_const)
	);
	pe_tile_top_right pe_tile_0_2(
		.in_wire_3_0(in_pad_2_pin_to_pe_tile_0_2_in_wire_3_0),
		.in_wire_3_1(pe_tile_0_2_in_wire_3_1_const),
		.in_wire_3_2(pe_tile_0_2_in_wire_3_2_const),
		.in_wire_3_3(pe_tile_0_2_in_wire_3_3_const),
		.out_wire_1_0(vertical_tile_0_2_to_tile_1_2_0),
		.out_wire_1_1(vertical_tile_0_2_to_tile_1_2_1),
		.out_wire_1_2(vertical_tile_0_2_to_tile_1_2_2),
		.out_wire_1_3(vertical_tile_0_2_to_tile_1_2_3),
		.in_wire_1_0(vertical_tile_1_2_to_tile_0_2_0),
		.in_wire_1_1(vertical_tile_1_2_to_tile_0_2_1),
		.in_wire_1_2(vertical_tile_1_2_to_tile_0_2_2),
		.in_wire_1_3(vertical_tile_1_2_to_tile_0_2_3),
		.out_wire_2_0(horizontal_tile_0_2_to_tile_0_1_0),
		.out_wire_2_1(horizontal_tile_0_2_to_tile_0_1_1),
		.out_wire_2_2(horizontal_tile_0_2_to_tile_0_1_2),
		.out_wire_2_3(horizontal_tile_0_2_to_tile_0_1_3),
		.in_wire_2_0(horizontal_tile_0_1_to_tile_0_2_0),
		.in_wire_2_1(horizontal_tile_0_1_to_tile_0_2_1),
		.in_wire_2_2(horizontal_tile_0_1_to_tile_0_2_2),
		.in_wire_2_3(horizontal_tile_0_1_to_tile_0_2_3),
		.in_wire_0_0(pe_tile_0_2_in_wire_0_0_const),
		.in_wire_0_1(pe_tile_0_2_in_wire_0_1_const),
		.in_wire_0_2(pe_tile_0_2_in_wire_0_2_const),
		.in_wire_0_3(pe_tile_0_2_in_wire_0_3_const),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_2_id_wire)
	);
	assign_mod assign_pe_tile_0_2_in_wire_0_0_const_15(
		.in(pe_tile_0_2_in_wire_0_0_const)
	);
	assign_mod assign_pe_tile_0_2_in_wire_3_1_const_12(
		.in(pe_tile_0_2_in_wire_3_1_const)
	);
	pe_tile_bottom_right pe_tile_2_2(
		.out_wire_3_0(vertical_tile_2_2_to_tile_1_2_0),
		.out_wire_3_1(vertical_tile_2_2_to_tile_1_2_1),
		.out_wire_3_2(vertical_tile_2_2_to_tile_1_2_2),
		.out_wire_3_3(vertical_tile_2_2_to_tile_1_2_3),
		.in_wire_3_0(vertical_tile_1_2_to_tile_2_2_0),
		.in_wire_3_1(vertical_tile_1_2_to_tile_2_2_1),
		.in_wire_3_2(vertical_tile_1_2_to_tile_2_2_2),
		.in_wire_3_3(vertical_tile_1_2_to_tile_2_2_3),
		.out_wire_1_0(out_pad_2_pin_to_pe_tile_2_2_out_wire_1_0),
		.in_wire_1_0(pe_tile_2_2_in_wire_1_0_const),
		.in_wire_1_1(pe_tile_2_2_in_wire_1_1_const),
		.in_wire_1_2(pe_tile_2_2_in_wire_1_2_const),
		.in_wire_1_3(pe_tile_2_2_in_wire_1_3_const),
		.out_wire_2_0(horizontal_tile_2_2_to_tile_2_1_0),
		.out_wire_2_1(horizontal_tile_2_2_to_tile_2_1_1),
		.out_wire_2_2(horizontal_tile_2_2_to_tile_2_1_2),
		.out_wire_2_3(horizontal_tile_2_2_to_tile_2_1_3),
		.in_wire_2_0(horizontal_tile_2_1_to_tile_2_2_0),
		.in_wire_2_1(horizontal_tile_2_1_to_tile_2_2_1),
		.in_wire_2_2(horizontal_tile_2_1_to_tile_2_2_2),
		.in_wire_2_3(horizontal_tile_2_1_to_tile_2_2_3),
		.in_wire_0_0(pe_tile_2_2_in_wire_0_0_const),
		.in_wire_0_1(pe_tile_2_2_in_wire_0_1_const),
		.in_wire_0_2(pe_tile_2_2_in_wire_0_2_const),
		.in_wire_0_3(pe_tile_2_2_in_wire_0_3_const),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_2_id_wire)
	);
	assign_mod assign_pe_tile_2_0in_wire_2_1_const_36(
		.in(pe_tile_2_0in_wire_2_1_const)
	);
	assign_mod assign_pe_tile_2_0in_wire_2_0_const_35(
		.in(pe_tile_2_0in_wire_2_0_const)
	);
	pe_tile_bottom_left pe_tile_2_0(
		.out_wire_3_0(vertical_tile_2_0_to_tile_1_0_0),
		.out_wire_3_1(vertical_tile_2_0_to_tile_1_0_1),
		.out_wire_3_2(vertical_tile_2_0_to_tile_1_0_2),
		.out_wire_3_3(vertical_tile_2_0_to_tile_1_0_3),
		.in_wire_3_0(vertical_tile_1_0_to_tile_2_0_0),
		.in_wire_3_1(vertical_tile_1_0_to_tile_2_0_1),
		.in_wire_3_2(vertical_tile_1_0_to_tile_2_0_2),
		.in_wire_3_3(vertical_tile_1_0_to_tile_2_0_3),
		.out_wire_1_0(out_pad_0_pin_to_pe_tile_2_0_out_wire_1_0),
		.in_wire_1_0(pe_tile_2_0_in_wire_1_0_const),
		.in_wire_1_1(pe_tile_2_0_in_wire_1_1_const),
		.in_wire_1_2(pe_tile_2_0_in_wire_1_2_const),
		.in_wire_1_3(pe_tile_2_0_in_wire_1_3_const),
		.in_wire_2_0(pe_tile_2_0in_wire_2_0_const),
		.in_wire_2_1(pe_tile_2_0in_wire_2_1_const),
		.in_wire_2_2(pe_tile_2_0in_wire_2_2_const),
		.in_wire_2_3(pe_tile_2_0in_wire_2_3_const),
		.out_wire_0_0(horizontal_tile_2_0_to_tile_2_1_0),
		.out_wire_0_1(horizontal_tile_2_0_to_tile_2_1_1),
		.out_wire_0_2(horizontal_tile_2_0_to_tile_2_1_2),
		.out_wire_0_3(horizontal_tile_2_0_to_tile_2_1_3),
		.in_wire_0_0(horizontal_tile_2_1_to_tile_2_0_0),
		.in_wire_0_1(horizontal_tile_2_1_to_tile_2_0_1),
		.in_wire_0_2(horizontal_tile_2_1_to_tile_2_0_2),
		.in_wire_0_3(horizontal_tile_2_1_to_tile_2_0_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_0_id_wire)
	);
	assign_mod assign_pe_tile_0_2_id_wire_19(
		.in(pe_tile_0_2_id_wire)
	);
	assign_mod assign_pe_tile_2_2_in_wire_0_1_const_50(
		.in(pe_tile_2_2_in_wire_0_1_const)
	);
	assign_mod assign_pe_tile_0_1_in_wire_3_2_const_9(
		.in(pe_tile_0_1_in_wire_3_2_const)
	);
	assign_mod assign_pe_tile_1_2_id_wire_30(
		.in(pe_tile_1_2_id_wire)
	);
	assign_mod assign_pe_tile_2_0_in_wire_1_0_const_31(
		.in(pe_tile_2_0_in_wire_1_0_const)
	);
	pe_tile pe_tile_1_1(
		.out_wire_3_0(vertical_tile_1_1_to_tile_0_1_0),
		.out_wire_3_1(vertical_tile_1_1_to_tile_0_1_1),
		.out_wire_3_2(vertical_tile_1_1_to_tile_0_1_2),
		.out_wire_3_3(vertical_tile_1_1_to_tile_0_1_3),
		.in_wire_3_0(vertical_tile_0_1_to_tile_1_1_0),
		.in_wire_3_1(vertical_tile_0_1_to_tile_1_1_1),
		.in_wire_3_2(vertical_tile_0_1_to_tile_1_1_2),
		.in_wire_3_3(vertical_tile_0_1_to_tile_1_1_3),
		.out_wire_1_0(vertical_tile_1_1_to_tile_2_1_0),
		.out_wire_1_1(vertical_tile_1_1_to_tile_2_1_1),
		.out_wire_1_2(vertical_tile_1_1_to_tile_2_1_2),
		.out_wire_1_3(vertical_tile_1_1_to_tile_2_1_3),
		.in_wire_1_0(vertical_tile_2_1_to_tile_1_1_0),
		.in_wire_1_1(vertical_tile_2_1_to_tile_1_1_1),
		.in_wire_1_2(vertical_tile_2_1_to_tile_1_1_2),
		.in_wire_1_3(vertical_tile_2_1_to_tile_1_1_3),
		.out_wire_2_0(horizontal_tile_1_1_to_tile_1_0_0),
		.out_wire_2_1(horizontal_tile_1_1_to_tile_1_0_1),
		.out_wire_2_2(horizontal_tile_1_1_to_tile_1_0_2),
		.out_wire_2_3(horizontal_tile_1_1_to_tile_1_0_3),
		.in_wire_2_0(horizontal_tile_1_0_to_tile_1_1_0),
		.in_wire_2_1(horizontal_tile_1_0_to_tile_1_1_1),
		.in_wire_2_2(horizontal_tile_1_0_to_tile_1_1_2),
		.in_wire_2_3(horizontal_tile_1_0_to_tile_1_1_3),
		.out_wire_0_0(horizontal_tile_1_1_to_tile_1_2_0),
		.out_wire_0_1(horizontal_tile_1_1_to_tile_1_2_1),
		.out_wire_0_2(horizontal_tile_1_1_to_tile_1_2_2),
		.out_wire_0_3(horizontal_tile_1_1_to_tile_1_2_3),
		.in_wire_0_0(horizontal_tile_1_2_to_tile_1_1_0),
		.in_wire_0_1(horizontal_tile_1_2_to_tile_1_1_1),
		.in_wire_0_2(horizontal_tile_1_2_to_tile_1_1_2),
		.in_wire_0_3(horizontal_tile_1_2_to_tile_1_1_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_1_id_wire)
	);
	assign_mod assign_pe_tile_0_1_in_wire_3_3_const_10(
		.in(pe_tile_0_1_in_wire_3_3_const)
	);
	assign_mod assign_pe_tile_1_0_id_wire_24(
		.in(pe_tile_1_0_id_wire)
	);
	pe_tile_top pe_tile_0_1(
		.in_wire_3_0(in_pad_1_pin_to_pe_tile_0_1_in_wire_3_0),
		.in_wire_3_1(pe_tile_0_1_in_wire_3_1_const),
		.in_wire_3_2(pe_tile_0_1_in_wire_3_2_const),
		.in_wire_3_3(pe_tile_0_1_in_wire_3_3_const),
		.out_wire_1_0(vertical_tile_0_1_to_tile_1_1_0),
		.out_wire_1_1(vertical_tile_0_1_to_tile_1_1_1),
		.out_wire_1_2(vertical_tile_0_1_to_tile_1_1_2),
		.out_wire_1_3(vertical_tile_0_1_to_tile_1_1_3),
		.in_wire_1_0(vertical_tile_1_1_to_tile_0_1_0),
		.in_wire_1_1(vertical_tile_1_1_to_tile_0_1_1),
		.in_wire_1_2(vertical_tile_1_1_to_tile_0_1_2),
		.in_wire_1_3(vertical_tile_1_1_to_tile_0_1_3),
		.out_wire_2_0(horizontal_tile_0_1_to_tile_0_0_0),
		.out_wire_2_1(horizontal_tile_0_1_to_tile_0_0_1),
		.out_wire_2_2(horizontal_tile_0_1_to_tile_0_0_2),
		.out_wire_2_3(horizontal_tile_0_1_to_tile_0_0_3),
		.in_wire_2_0(horizontal_tile_0_0_to_tile_0_1_0),
		.in_wire_2_1(horizontal_tile_0_0_to_tile_0_1_1),
		.in_wire_2_2(horizontal_tile_0_0_to_tile_0_1_2),
		.in_wire_2_3(horizontal_tile_0_0_to_tile_0_1_3),
		.out_wire_0_0(horizontal_tile_0_1_to_tile_0_2_0),
		.out_wire_0_1(horizontal_tile_0_1_to_tile_0_2_1),
		.out_wire_0_2(horizontal_tile_0_1_to_tile_0_2_2),
		.out_wire_0_3(horizontal_tile_0_1_to_tile_0_2_3),
		.in_wire_0_0(horizontal_tile_0_2_to_tile_0_1_0),
		.in_wire_0_1(horizontal_tile_0_2_to_tile_0_1_1),
		.in_wire_0_2(horizontal_tile_0_2_to_tile_0_1_2),
		.in_wire_0_3(horizontal_tile_0_2_to_tile_0_1_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_1_id_wire)
	);
	assign_mod assign_pe_tile_2_0_in_wire_1_2_const_33(
		.in(pe_tile_2_0_in_wire_1_2_const)
	);
	assign_mod assign_pe_tile_2_1_in_wire_1_0_const_40(
		.in(pe_tile_2_1_in_wire_1_0_const)
	);
	assign_mod assign_pe_tile_2_1_in_wire_1_1_const_41(
		.in(pe_tile_2_1_in_wire_1_1_const)
	);
	pe_tile_top_left pe_tile_0_0(
		.in_wire_3_0(in_pad_0_pin_to_pe_tile_0_0_in_wire_3_0),
		.in_wire_3_1(pe_tile_0_0_in_wire_3_1_const),
		.in_wire_3_2(pe_tile_0_0_in_wire_3_2_const),
		.in_wire_3_3(pe_tile_0_0_in_wire_3_3_const),
		.out_wire_1_0(vertical_tile_0_0_to_tile_1_0_0),
		.out_wire_1_1(vertical_tile_0_0_to_tile_1_0_1),
		.out_wire_1_2(vertical_tile_0_0_to_tile_1_0_2),
		.out_wire_1_3(vertical_tile_0_0_to_tile_1_0_3),
		.in_wire_1_0(vertical_tile_1_0_to_tile_0_0_0),
		.in_wire_1_1(vertical_tile_1_0_to_tile_0_0_1),
		.in_wire_1_2(vertical_tile_1_0_to_tile_0_0_2),
		.in_wire_1_3(vertical_tile_1_0_to_tile_0_0_3),
		.in_wire_2_0(pe_tile_0_0in_wire_2_0_const),
		.in_wire_2_1(pe_tile_0_0in_wire_2_1_const),
		.in_wire_2_2(pe_tile_0_0in_wire_2_2_const),
		.in_wire_2_3(pe_tile_0_0in_wire_2_3_const),
		.out_wire_0_0(horizontal_tile_0_0_to_tile_0_1_0),
		.out_wire_0_1(horizontal_tile_0_0_to_tile_0_1_1),
		.out_wire_0_2(horizontal_tile_0_0_to_tile_0_1_2),
		.out_wire_0_3(horizontal_tile_0_0_to_tile_0_1_3),
		.in_wire_0_0(horizontal_tile_0_1_to_tile_0_0_0),
		.in_wire_0_1(horizontal_tile_0_1_to_tile_0_0_1),
		.in_wire_0_2(horizontal_tile_0_1_to_tile_0_0_2),
		.in_wire_0_3(horizontal_tile_0_1_to_tile_0_0_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_0_id_wire)
	);
	assign_mod assign_pe_tile_0_1_id_wire_11(
		.in(pe_tile_0_1_id_wire)
	);
	assign_mod assign_pe_tile_0_0in_wire_2_2_const_5(
		.in(pe_tile_0_0in_wire_2_2_const)
	);
	assign_mod assign_pe_tile_2_0_id_wire_39(
		.in(pe_tile_2_0_id_wire)
	);
	assign_mod assign_pe_tile_2_0in_wire_2_2_const_37(
		.in(pe_tile_2_0in_wire_2_2_const)
	);
	assign_mod assign_pe_tile_2_2_in_wire_1_2_const_47(
		.in(pe_tile_2_2_in_wire_1_2_const)
	);
	assign_mod assign_pe_tile_0_0_id_wire_7(
		.in(pe_tile_0_0_id_wire)
	);
	assign_mod assign_pe_tile_0_0in_wire_2_3_const_6(
		.in(pe_tile_0_0in_wire_2_3_const)
	);
	// Assignments 
	assign pe_tile_2_2_in_wire_1_3_const = 1'b0;
	assign pe_tile_0_0in_wire_2_1_const = 1'b0;
	assign pe_tile_2_2_in_wire_1_1_const = 1'b0;
	assign pe_tile_2_1_in_wire_1_1_const = 1'b0;
	assign pe_tile_0_0_in_wire_3_1_const = 1'b0;
	assign pe_tile_1_2_in_wire_0_0_const = 1'b0;
	assign pe_tile_0_0_in_wire_3_3_const = 1'b0;
	assign pe_tile_1_2_in_wire_0_3_const = 1'b0;
	assign pe_tile_2_0in_wire_2_3_const = 1'b0;
	assign pe_tile_1_0in_wire_2_3_const = 1'b0;
	assign pe_tile_0_2_in_wire_3_1_const = 1'b0;
	assign pe_tile_0_0_in_wire_3_2_const = 1'b0;
	assign pe_tile_1_2_in_wire_0_2_const = 1'b0;
	assign pe_tile_2_1_in_wire_1_0_const = 1'b0;
	assign pe_tile_2_0_in_wire_1_0_const = 1'b0;
	assign pe_tile_1_1_id_wire = 5;
	assign pe_tile_0_2_id_wire = 3;
	assign pe_tile_2_0_in_wire_1_3_const = 1'b0;
	assign pe_tile_1_0in_wire_2_1_const = 1'b0;
	assign pe_tile_2_2_in_wire_0_3_const = 1'b0;
	assign pe_tile_2_2_in_wire_1_2_const = 1'b0;
	assign pe_tile_2_0in_wire_2_0_const = 1'b0;
	assign pe_tile_0_2_in_wire_3_3_const = 1'b0;
	assign pe_tile_1_2_id_wire = 6;
	assign pe_tile_2_2_in_wire_0_0_const = 1'b0;
	assign pe_tile_2_0in_wire_2_1_const = 1'b0;
	assign pe_tile_2_0_id_wire = 7;
	assign pe_tile_2_2_in_wire_1_0_const = 1'b0;
	assign pe_tile_2_2_in_wire_0_2_const = 1'b0;
	assign pe_tile_2_1_id_wire = 8;
	assign pe_tile_0_1_id_wire = 2;
	assign pe_tile_2_2_in_wire_0_1_const = 1'b0;
	assign pe_tile_2_1_in_wire_1_2_const = 1'b0;
	assign pe_tile_0_0in_wire_2_0_const = 1'b0;
	assign pe_tile_0_1_in_wire_3_1_const = 1'b0;
	assign pe_tile_0_1_in_wire_3_2_const = 1'b0;
	assign pe_tile_0_0_id_wire = 1;
	assign pe_tile_2_1_in_wire_1_3_const = 1'b0;
	assign pe_tile_0_2_in_wire_3_2_const = 1'b0;
	assign pe_tile_0_2_in_wire_0_3_const = 1'b0;
	assign pe_tile_2_2_id_wire = 9;
	assign pe_tile_0_0in_wire_2_2_const = 1'b0;
	assign pe_tile_0_1_in_wire_3_3_const = 1'b0;
	assign pe_tile_2_0in_wire_2_2_const = 1'b0;
	assign pe_tile_0_2_in_wire_0_0_const = 1'b0;
	assign pe_tile_0_0in_wire_2_3_const = 1'b0;
	assign pe_tile_2_0_in_wire_1_1_const = 1'b0;
	assign pe_tile_0_2_in_wire_0_1_const = 1'b0;
	assign pe_tile_0_2_in_wire_0_2_const = 1'b0;
	assign pe_tile_1_2_in_wire_0_1_const = 1'b0;
	assign pe_tile_1_0_id_wire = 4;
	assign pe_tile_1_0in_wire_2_2_const = 1'b0;
	assign pe_tile_2_0_in_wire_1_2_const = 1'b0;
	assign pe_tile_1_0in_wire_2_0_const = 1'b0;


endmodule
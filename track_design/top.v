

module top(
	input [0 : 0] reset,
	input [31 : 0] config_data,
	input [0 : 0] in_wire_2,
	input [0 : 0] in_wire_1,
	input [0 : 0] clk,
	input [0 : 0] in_wire_0,
	input [31 : 0] config_addr,
	output [0 : 0] out_wire_2,
	output [0 : 0] out_wire_1,
	output [0 : 0] out_wire_0
	);

	// Internal wires
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_8;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_9;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_2;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_4;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_5;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_6;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_7;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_0_to_tile_1_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] in_pad_1_pin_to_pe_tile_0_1_side_3_track_0_in;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_3_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_2_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_3_const;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_0_2_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_0_to_tile_1_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_0_1_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_1_to_tile_0_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_2_to_tile_0_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_0_0_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_0_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_2_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_1_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_1_to_tile_1_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_2_0_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_1_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_2_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_12;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_2_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] wire_10;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_11;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_1_in_wire_3_1_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_0_to_tile_1_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_1_1_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_2_2_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] in_pad_0_pin_to_pe_tile_0_0_side_3_track_0_in;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_2_to_tile_1_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_2_1_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_2_to_tile_2_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_2_in_wire_3_3_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_2_to_tile_0_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_tile_0_0_in_wire_3_2_const;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_1_to_tile_1_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] in_pad_2_pin_to_pe_tile_0_2_side_3_track_0_in;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_13;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_1_2_to_tile_1_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_1_0_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] pe_tile_1_2_id_wire;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_1_0_to_tile_2_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_0_to_tile_0_1_2;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_16;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_17;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_14;
	/* verilator lint_off UNOPTFLAT */
	wire [16 - 1 : 0] wire_15;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_0_1_to_tile_0_2_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_0_1_to_tile_1_1_3;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] vertical_tile_2_2_to_tile_1_2_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_0_to_tile_2_1_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] horizontal_tile_2_1_to_tile_2_0_3;
	// End of wire declarations

	io1out_pad out_pad_2(
		.top_pin(out_wire_2),
		.clk(clk)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_0_in_wire_3_3_const_2(
		.out(pe_tile_0_0_in_wire_3_3_const),
		.in(wire_2)
	);

	io1out_pad out_pad_0(
		.top_pin(out_wire_0),
		.clk(clk)
	);

	io1out_pad out_pad_1(
		.top_pin(out_wire_1),
		.clk(clk)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_1_in_wire_3_1_const_4(
		.out(pe_tile_0_1_in_wire_3_1_const),
		.in(wire_4)
	);

	assign_mod #(.width(16))  assign_pe_tile_1_0_id_wire_12(
		.out(pe_tile_1_0_id_wire),
		.in(wire_12)
	);

	pe_tile pe_tile_1_1(
		.side_3_track_0_out(vertical_tile_1_1_to_tile_0_1_0),
		.side_3_track_1_out(vertical_tile_1_1_to_tile_0_1_1),
		.side_3_track_2_out(vertical_tile_1_1_to_tile_0_1_2),
		.side_3_track_3_out(vertical_tile_1_1_to_tile_0_1_3),
		.side_3_track_0_in(vertical_tile_0_1_to_tile_1_1_0),
		.side_3_track_1_in(vertical_tile_0_1_to_tile_1_1_1),
		.side_3_track_2_in(vertical_tile_0_1_to_tile_1_1_2),
		.side_3_track_3_in(vertical_tile_0_1_to_tile_1_1_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_1_id_wire)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_1_in_wire_3_2_const_5(
		.out(pe_tile_0_1_in_wire_3_2_const),
		.in(wire_5)
	);

	const_mod #(.width(16), .value(7))  assign_pe_tile_2_0_id_wire_15_const(
		.out(wire_15)
	);

	const_mod #(.width(16), .value(9))  assign_pe_tile_2_2_id_wire_17_const(
		.out(wire_17)
	);

	pe_tile pe_tile_1_2(
		.side_3_track_0_out(vertical_tile_1_2_to_tile_0_2_0),
		.side_3_track_1_out(vertical_tile_1_2_to_tile_0_2_1),
		.side_3_track_2_out(vertical_tile_1_2_to_tile_0_2_2),
		.side_3_track_3_out(vertical_tile_1_2_to_tile_0_2_3),
		.side_3_track_0_in(vertical_tile_0_2_to_tile_1_2_0),
		.side_3_track_1_in(vertical_tile_0_2_to_tile_1_2_1),
		.side_3_track_2_in(vertical_tile_0_2_to_tile_1_2_2),
		.side_3_track_3_in(vertical_tile_0_2_to_tile_1_2_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_2_id_wire)
	);

	pe_tile pe_tile_1_0(
		.side_3_track_0_out(vertical_tile_1_0_to_tile_0_0_0),
		.side_3_track_1_out(vertical_tile_1_0_to_tile_0_0_1),
		.side_3_track_2_out(vertical_tile_1_0_to_tile_0_0_2),
		.side_3_track_3_out(vertical_tile_1_0_to_tile_0_0_3),
		.side_3_track_0_in(vertical_tile_0_0_to_tile_1_0_0),
		.side_3_track_1_in(vertical_tile_0_0_to_tile_1_0_1),
		.side_3_track_2_in(vertical_tile_0_0_to_tile_1_0_2),
		.side_3_track_3_in(vertical_tile_0_0_to_tile_1_0_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_1_0_id_wire)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_2_in_wire_3_3_const_10_const(
		.out(wire_10)
	);

	pe_tile pe_tile_0_2(
		.side_3_track_0_in(in_pad_2_pin_to_pe_tile_0_2_side_3_track_0_in),
		.side_3_track_1_in(pe_tile_0_2_in_wire_3_1_const),
		.side_3_track_2_in(pe_tile_0_2_in_wire_3_2_const),
		.side_3_track_3_in(pe_tile_0_2_in_wire_3_3_const),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_2_id_wire)
	);

	pe_tile pe_tile_0_1(
		.side_3_track_0_in(in_pad_1_pin_to_pe_tile_0_1_side_3_track_0_in),
		.side_3_track_1_in(pe_tile_0_1_in_wire_3_1_const),
		.side_3_track_2_in(pe_tile_0_1_in_wire_3_2_const),
		.side_3_track_3_in(pe_tile_0_1_in_wire_3_3_const),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_1_id_wire)
	);

	pe_tile pe_tile_0_0(
		.side_3_track_0_in(in_pad_0_pin_to_pe_tile_0_0_side_3_track_0_in),
		.side_3_track_1_in(pe_tile_0_0_in_wire_3_1_const),
		.side_3_track_2_in(pe_tile_0_0_in_wire_3_2_const),
		.side_3_track_3_in(pe_tile_0_0_in_wire_3_3_const),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_0_0_id_wire)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_2_in_wire_3_2_const_9_const(
		.out(wire_9)
	);

	pe_tile pe_tile_2_1(
		.side_3_track_0_out(vertical_tile_2_1_to_tile_1_1_0),
		.side_3_track_1_out(vertical_tile_2_1_to_tile_1_1_1),
		.side_3_track_2_out(vertical_tile_2_1_to_tile_1_1_2),
		.side_3_track_3_out(vertical_tile_2_1_to_tile_1_1_3),
		.side_3_track_0_in(vertical_tile_1_1_to_tile_2_1_0),
		.side_3_track_1_in(vertical_tile_1_1_to_tile_2_1_1),
		.side_3_track_2_in(vertical_tile_1_1_to_tile_2_1_2),
		.side_3_track_3_in(vertical_tile_1_1_to_tile_2_1_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_1_id_wire)
	);

	pe_tile pe_tile_2_0(
		.side_3_track_0_out(vertical_tile_2_0_to_tile_1_0_0),
		.side_3_track_1_out(vertical_tile_2_0_to_tile_1_0_1),
		.side_3_track_2_out(vertical_tile_2_0_to_tile_1_0_2),
		.side_3_track_3_out(vertical_tile_2_0_to_tile_1_0_3),
		.side_3_track_0_in(vertical_tile_1_0_to_tile_2_0_0),
		.side_3_track_1_in(vertical_tile_1_0_to_tile_2_0_1),
		.side_3_track_2_in(vertical_tile_1_0_to_tile_2_0_2),
		.side_3_track_3_in(vertical_tile_1_0_to_tile_2_0_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_0_id_wire)
	);

	pe_tile pe_tile_2_2(
		.side_3_track_0_out(vertical_tile_2_2_to_tile_1_2_0),
		.side_3_track_1_out(vertical_tile_2_2_to_tile_1_2_1),
		.side_3_track_2_out(vertical_tile_2_2_to_tile_1_2_2),
		.side_3_track_3_out(vertical_tile_2_2_to_tile_1_2_3),
		.side_3_track_0_in(vertical_tile_1_2_to_tile_2_2_0),
		.side_3_track_1_in(vertical_tile_1_2_to_tile_2_2_1),
		.side_3_track_2_in(vertical_tile_1_2_to_tile_2_2_2),
		.side_3_track_3_in(vertical_tile_1_2_to_tile_2_2_3),
		.clk(clk),
		.rst(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(pe_tile_2_2_id_wire)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_1_in_wire_3_1_const_4_const(
		.out(wire_4)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_2_in_wire_3_1_const_8_const(
		.out(wire_8)
	);

	assign_mod #(.width(16))  assign_pe_tile_1_1_id_wire_13(
		.out(pe_tile_1_1_id_wire),
		.in(wire_13)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_0_in_wire_3_1_const_0(
		.out(pe_tile_0_0_in_wire_3_1_const),
		.in(wire_0)
	);

	assign_mod #(.width(16))  assign_pe_tile_2_1_id_wire_16(
		.out(pe_tile_2_1_id_wire),
		.in(wire_16)
	);

	const_mod #(.width(16), .value(8))  assign_pe_tile_2_1_id_wire_16_const(
		.out(wire_16)
	);

	const_mod #(.width(16), .value(5))  assign_pe_tile_1_1_id_wire_13_const(
		.out(wire_13)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_1_in_wire_3_2_const_5_const(
		.out(wire_5)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_2_in_wire_3_1_const_8(
		.out(pe_tile_0_2_in_wire_3_1_const),
		.in(wire_8)
	);

	const_mod #(.width(16), .value(4))  assign_pe_tile_1_0_id_wire_12_const(
		.out(wire_12)
	);

	assign_mod #(.width(16))  assign_pe_tile_0_1_id_wire_7(
		.out(pe_tile_0_1_id_wire),
		.in(wire_7)
	);

	const_mod #(.width(16), .value(1))  assign_pe_tile_0_0_id_wire_3_const(
		.out(wire_3)
	);

	const_mod #(.width(16), .value(2))  assign_pe_tile_0_1_id_wire_7_const(
		.out(wire_7)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_2_in_wire_3_2_const_9(
		.out(pe_tile_0_2_in_wire_3_2_const),
		.in(wire_9)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_0_in_wire_3_1_const_0_const(
		.out(wire_0)
	);

	assign_mod #(.width(16))  assign_pe_tile_0_0_id_wire_3(
		.out(pe_tile_0_0_id_wire),
		.in(wire_3)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_0_in_wire_3_2_const_1_const(
		.out(wire_1)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_2_in_wire_3_3_const_10(
		.out(pe_tile_0_2_in_wire_3_3_const),
		.in(wire_10)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_0_in_wire_3_2_const_1(
		.out(pe_tile_0_0_in_wire_3_2_const),
		.in(wire_1)
	);

	const_mod #(.width(16), .value(3))  assign_pe_tile_0_2_id_wire_11_const(
		.out(wire_11)
	);

	const_mod #(.width(16), .value(6))  assign_pe_tile_1_2_id_wire_14_const(
		.out(wire_14)
	);

	assign_mod #(.width(16))  assign_pe_tile_1_2_id_wire_14(
		.out(pe_tile_1_2_id_wire),
		.in(wire_14)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_1_in_wire_3_3_const_6_const(
		.out(wire_6)
	);

	assign_mod #(.width(16))  assign_pe_tile_2_0_id_wire_15(
		.out(pe_tile_2_0_id_wire),
		.in(wire_15)
	);

	assign_mod #(.width(16))  assign_pe_tile_0_2_id_wire_11(
		.out(pe_tile_0_2_id_wire),
		.in(wire_11)
	);

	io1in_pad in_pad_2(
		.clk(clk),
		.top_pin(in_wire_2),
		.pin(in_pad_2_pin_to_pe_tile_0_2_side_3_track_0_in)
	);

	io1in_pad in_pad_0(
		.clk(clk),
		.top_pin(in_wire_0),
		.pin(in_pad_0_pin_to_pe_tile_0_0_side_3_track_0_in)
	);

	io1in_pad in_pad_1(
		.clk(clk),
		.top_pin(in_wire_1),
		.pin(in_pad_1_pin_to_pe_tile_0_1_side_3_track_0_in)
	);

	assign_mod #(.width(16))  assign_pe_tile_2_2_id_wire_17(
		.out(pe_tile_2_2_id_wire),
		.in(wire_17)
	);

	const_mod #(.width(1), .value(1'b0))  assign_pe_tile_0_0_in_wire_3_3_const_2_const(
		.out(wire_2)
	);

	assign_mod #(.width(1))  assign_pe_tile_0_1_in_wire_3_3_const_6(
		.out(pe_tile_0_1_in_wire_3_3_const),
		.in(wire_6)
	);



endmodule
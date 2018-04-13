module pe_tile_top_right(input [0 : 0] reset, input [31 : 0] config_data, input [0 : 0] in_wire_2_1, input [0 : 0] in_wire_0_0, input [0 : 0] in_wire_0_1, input [0 : 0] in_wire_0_2, input [0 : 0] clk, input [0 : 0] in_wire_2_2, input [0 : 0] in_wire_2_3, input [0 : 0] in_wire_1_2, input [0 : 0] in_wire_0_3, input [0 : 0] in_wire_1_1, input [0 : 0] in_wire_1_0, input [0 : 0] in_wire_1_3, input [31 : 0] config_addr, input [0 : 0] in_wire_3_3, input [0 : 0] in_wire_3_2, input [0 : 0] in_wire_3_1, input [0 : 0] in_wire_3_0, input [15 : 0] tile_id, input [0 : 0] in_wire_2_0, output [0 : 0] out_wire_2_2, output [0 : 0] out_wire_2_3, output [0 : 0] out_wire_2_0, output [0 : 0] out_wire_2_1, output [0 : 0] out_wire_1_1, output [0 : 0] out_wire_1_0, output [0 : 0] out_wire_1_3, output [0 : 0] out_wire_1_2);
	// Internal wires
	wire [1 - 1 : 0] config_en_cb1;
	wire [1 - 1 : 0] config_en_cb0;
	wire [1 - 1 : 0] op_0;
	wire [1 - 1 : 0] op_1;
	wire [1 - 1 : 0] out_wire_0_0;
	wire [1 - 1 : 0] out_wire_0_1;
	wire [1 - 1 : 0] out_wire_0_2;
	wire [1 - 1 : 0] out_wire_0_3;
	wire [1 - 1 : 0] config_en_pe;
	wire [1 - 1 : 0] config_en_sb;
	wire [1 - 1 : 0] pe_output;
	// End of wire declarations

	address_matcher #(.tile_id(1), .config_id(1))  pe_address_matcher(
		.config_reg(config_en_pe)
	);

	address_matcher #(.tile_id(1), .config_id(1))  sb_address_matcher(
		.config_reg(config_en_sb)
	);

	address_matcher #(.tile_id(1), .config_id(1))  cb1_address_matcher(
		.config_reg(config_en_cb1)
	);

	connect_box cb0(
		.config_en(config_en_cb0),
		.track0_in(in_wire_0_0),
		.track1_in(in_wire_0_1),
		.track2_in(in_wire_0_2),
		.track3_in(in_wire_0_3),
		.track4_in(out_wire_0_0),
		.track5_in(out_wire_0_1),
		.track6_in(out_wire_0_2),
		.track7_in(out_wire_0_3),
		.clk(clk)
	);

	connect_box cb1(
		.config_en(config_en_cb1),
		.clk(clk),
		.track0_in(in_wire_0_0),
		.track1_in(in_wire_0_1),
		.track2_in(in_wire_0_2),
		.track3_in(in_wire_0_3),
		.track4_in(out_wire_0_0),
		.track5_in(out_wire_0_1),
		.track6_in(out_wire_0_2),
		.track7_in(out_wire_0_3)
	);

	switch_box_top_right sb(
		.config_en(config_en_sb),
		.clk(clk)
	);

	address_matcher #(.tile_id(1), .config_id(1))  cb0_address_matcher(
		.config_reg(config_en_cb0)
	);

endmodule
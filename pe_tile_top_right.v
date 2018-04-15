module pe_tile_top_right(input [0 : 0] reset, input [31 : 0] config_data, input [0 : 0] in_wire_2_1, input [0 : 0] in_wire_0_0, input [0 : 0] in_wire_0_1, input [0 : 0] in_wire_0_2, input [0 : 0] clk, input [0 : 0] in_wire_2_2, input [0 : 0] in_wire_2_3, input [0 : 0] in_wire_1_2, input [0 : 0] in_wire_0_3, input [0 : 0] in_wire_1_1, input [0 : 0] in_wire_1_0, input [0 : 0] in_wire_1_3, input [31 : 0] config_addr, input [0 : 0] in_wire_3_3, input [0 : 0] in_wire_3_2, input [0 : 0] in_wire_3_1, input [0 : 0] in_wire_3_0, input [15 : 0] tile_id, input [0 : 0] in_wire_2_0, output [0 : 0] out_wire_2_2, output [0 : 0] out_wire_2_3, output [0 : 0] out_wire_2_0, output [0 : 0] out_wire_2_1, output [0 : 0] out_wire_1_1, output [0 : 0] out_wire_1_0, output [0 : 0] out_wire_1_3, output [0 : 0] out_wire_1_2, output [0 : 0] out_wire_0_0, output [0 : 0] out_wire_0_1, output [0 : 0] out_wire_0_2, output [0 : 0] out_wire_0_3);
	// Internal wires
	wire [1 - 1 : 0] config_en_cb1;
	wire [1 - 1 : 0] config_en_cb0;
	wire [1 - 1 : 0] op_0;
	wire [1 - 1 : 0] op_1;
	wire [1 - 1 : 0] config_en_sb;
	wire [1 - 1 : 0] pe_output;
	wire [1 - 1 : 0] config_en_logic_block;
	// End of wire declarations

	address_matcher #(.tile_id(1), .config_id(1))  logic_block_address_matcher(
		.config_reg(config_en_logic_block)
	);

	clb logic_block(
		.config_enable(config_en_logic_block),
		.in0(op_0),
		.in1(op_1),
		.out(pe_output),
		.clk(clk)
	);

	address_matcher #(.tile_id(1), .config_id(1))  sb_address_matcher(
		.config_reg(config_en_sb)
	);

	address_matcher #(.tile_id(1), .config_id(1))  cb1_address_matcher(
		.config_reg(config_en_cb1)
	);

	connect_box cb0(
		.config_en(config_en_cb0),
		.block_out(op_0),
		.clk(clk),
		.track0_in(in_wire_0_0),
		.track1_in(in_wire_0_1),
		.track2_in(in_wire_0_2),
		.track3_in(in_wire_0_3),
		.track4_in(in_wire_0_3),
		.track5_in(in_wire_0_3),
		.track6_in(in_wire_0_3),
		.track7_in(in_wire_0_3)
	);

	connect_box cb1(
		.config_en(config_en_cb1),
		.block_out(op_1),
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
		.config_data(config_data),
		.pe_output_0(pe_output),
		.reset(reset),
		.clk(clk),
		.in_wire_0_0(in_wire_0_0),
		.in_wire_0_1(in_wire_0_1),
		.in_wire_0_2(in_wire_0_2),
		.in_wire_0_3(in_wire_0_3),
		.in_wire_1_0(in_wire_1_0),
		.in_wire_1_1(in_wire_1_1),
		.in_wire_1_2(in_wire_1_2),
		.in_wire_1_3(in_wire_1_3),
		.in_wire_2_0(in_wire_2_0),
		.in_wire_2_1(in_wire_2_1),
		.in_wire_2_2(in_wire_2_2),
		.in_wire_2_3(in_wire_2_3),
		.in_wire_3_0(in_wire_3_0),
		.in_wire_3_1(in_wire_3_1),
		.in_wire_3_2(in_wire_3_2),
		.in_wire_3_3(in_wire_3_3),
		.out_wire_0_0(out_wire_0_0),
		.out_wire_0_1(out_wire_0_1),
		.out_wire_0_2(out_wire_0_2),
		.out_wire_0_3(out_wire_0_3),
		.out_wire_1_0(out_wire_1_0),
		.out_wire_1_1(out_wire_1_1),
		.out_wire_1_2(out_wire_1_2),
		.out_wire_1_3(out_wire_1_3),
		.out_wire_2_0(out_wire_2_0),
		.out_wire_2_1(out_wire_2_1),
		.out_wire_2_2(out_wire_2_2),
		.out_wire_2_3(out_wire_2_3)
	);

	address_matcher #(.tile_id(1), .config_id(1))  cb0_address_matcher(
		.config_reg(config_en_cb0)
	);

endmodule
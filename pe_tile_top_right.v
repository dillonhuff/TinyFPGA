module pe_tile_top_right(input [0 : 0] reset, input [31 : 0] config_data, input [0 : 0] in_wire_2_1, input [0 : 0] in_wire_0_0, input [0 : 0] in_wire_0_1, input [0 : 0] in_wire_0_2, input [0 : 0] clk, input [0 : 0] in_wire_2_2, input [0 : 0] in_wire_2_3, input [0 : 0] in_wire_1_2, input [0 : 0] in_wire_0_3, input [0 : 0] in_wire_1_1, input [0 : 0] in_wire_1_0, input [0 : 0] in_wire_1_3, input [31 : 0] config_addr, input [0 : 0] in_wire_3_3, input [0 : 0] in_wire_3_2, input [0 : 0] in_wire_3_1, input [0 : 0] in_wire_3_0, input [15 : 0] tile_id, input [0 : 0] in_wire_2_0, output [0 : 0] out_wire_2_2, output [0 : 0] out_wire_2_3, output [0 : 0] out_wire_2_0, output [0 : 0] out_wire_2_1, output [0 : 0] out_wire_1_1, output [0 : 0] out_wire_1_0, output [0 : 0] out_wire_1_3, output [0 : 0] out_wire_1_2);
	// Internal wires
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] config_en_cb1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] config_en_cb0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] op_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] op_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] out_wire_0_0;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] out_wire_0_1;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] out_wire_0_2;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] out_wire_0_3;
	/* verilator lint_off UNOPTFLAT */
	wire [3 - 1 : 0] cb0_config_data;
	/* verilator lint_off UNOPTFLAT */
	wire [2 - 1 : 0] clb_config_data;
	/* verilator lint_off UNOPTFLAT */
	wire [3 - 1 : 0] cb1_config_data;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] config_en_sb;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] pe_output;
	/* verilator lint_off UNOPTFLAT */
	wire [1 - 1 : 0] config_en_logic_block;
	// End of wire declarations

	address_matcher #(.mod_id_end(31), .tile_id_end(15), .mod_id_begin(16), .tile_id_begin(0), .config_flag_value(4))  logic_block_address_matcher(
		.config_reg(config_en_logic_block),
		.tile_id(tile_id),
		.config_addr(config_addr)
	);

	slice_mod #(.end_ind(1), .start_ind(0))  clb_slice(
		.in(config_data),
		.out(clb_config_data)
	);

	slice_mod #(.end_ind(2), .start_ind(0))  cb1_slice(
		.in(config_data),
		.out(cb1_config_data)
	);

	clb logic_block(
		.config_enable(config_en_logic_block),
		.in0(op_0),
		.in1(op_1),
		.out(pe_output),
		.config_data(clb_config_data),
		.clk(clk)
	);

	address_matcher #(.mod_id_end(31), .tile_id_end(15), .mod_id_begin(16), .tile_id_begin(0), .config_flag_value(7))  sb_address_matcher(
		.config_reg(config_en_sb),
		.tile_id(tile_id),
		.config_addr(config_addr)
	);

	address_matcher #(.mod_id_end(31), .tile_id_end(15), .mod_id_begin(16), .tile_id_begin(0), .config_flag_value(5))  cb1_address_matcher(
		.config_reg(config_en_cb1),
		.tile_id(tile_id),
		.config_addr(config_addr)
	);

	connect_box cb0(
		.config_en(config_en_cb0),
		.block_out(op_0),
		.config_data(cb0_config_data),
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

	slice_mod #(.end_ind(2), .start_ind(0))  cb0_slice(
		.in(config_data),
		.out(cb0_config_data)
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

	address_matcher #(.mod_id_end(31), .tile_id_end(15), .mod_id_begin(16), .tile_id_begin(0), .config_flag_value(6))  cb0_address_matcher(
		.config_reg(config_en_cb0),
		.tile_id(tile_id),
		.config_addr(config_addr)
	);

	connect_box cb1(
		.config_en(config_en_cb1),
		.block_out(op_1),
		.config_data(cb1_config_data),
		.clk(clk),
		.track0_in(in_wire_1_0),
		.track1_in(in_wire_1_1),
		.track2_in(in_wire_1_2),
		.track3_in(in_wire_1_3),
		.track4_in(out_wire_1_0),
		.track5_in(out_wire_1_1),
		.track6_in(out_wire_1_2),
		.track7_in(out_wire_1_3)
	);

endmodule
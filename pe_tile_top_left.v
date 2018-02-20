`ifndef clb_v_included
`define clb_v_included 1
`include "clb.v"
`endif

`ifndef connect_box_v_included
`define connect_box_v_included 1
`include "connect_box.v"
`endif

`ifndef switch_box_v_included
`define switch_box_v_included 1
`include "switch_box.v"
`endif



module pe_tile_top_left(
	input clk,
	input reset,
	input [31:0] config_addr,
	input [31:0] config_data,
	input [15:0] tile_id,
	input in_wire_3_1,
	input in_wire_3_0,
	input in_wire_3_3,
	input in_wire_3_2,
	input in_wire_2_0,
	input in_wire_2_1,
	input in_wire_2_2,
	input in_wire_2_3,
	input in_wire_1_3,
	input in_wire_1_2,
	input in_wire_1_1,
	input in_wire_1_0,
	input in_wire_0_2,
	input in_wire_0_3,
	input in_wire_0_0,
	input in_wire_0_1,
	output out_wire_1_3,
	output out_wire_1_2,
	output out_wire_1_1,
	output out_wire_1_0,
	output out_wire_0_2,
	output out_wire_0_3,
	output out_wire_0_0,
	output out_wire_0_1
	);


	wire op_0;
	wire op_1;
	/* verilator lint_off UNOPTFLAT */
	wire pe_output;

	// Local wires for switch box outputs <-> connect box
	// Set configuration flag
	reg config_en_compute_block;
	localparam CONFIG_compute_block = 4;
	always @(*) begin
		if ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_compute_block)) begin
			config_en_compute_block = 1'b1;
		end else begin
			config_en_compute_block = 1'b0;
		end
	end



	// Declare module
	clb compute_block(
		.config_data(config_data[1:0]),
		.clk(clk),
		.config_enable(config_en_compute_block),
		.in0(op_0),
		.in1(op_1),
		.out(pe_output)
	);

	// Set configuration flag
	reg config_en_sb;
	localparam CONFIG_sb = 7;
	always @(*) begin
		if ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_sb)) begin
			config_en_sb = 1'b1;
		end else begin
			config_en_sb = 1'b0;
		end
	end



	// Declare module
	switch_box_top_left sb(
		.config_en(config_en_sb),
		.out_wire_1_1(out_wire_1_1),
		.out_wire_1_0(out_wire_1_0),
		.out_wire_1_3(out_wire_1_3),
		.out_wire_1_2(out_wire_1_2),
		.out_wire_0_0(out_wire_0_0),
		.out_wire_0_1(out_wire_0_1),
		.out_wire_0_2(out_wire_0_2),
		.out_wire_0_3(out_wire_0_3),
		.pe_output_0(pe_output),
		.clk(clk),
		.in_wire_2_2(in_wire_2_2),
		.in_wire_2_3(in_wire_2_3),
		.in_wire_2_0(in_wire_2_0),
		.in_wire_2_1(in_wire_2_1),
		.in_wire_3_3(in_wire_3_3),
		.in_wire_3_2(in_wire_3_2),
		.in_wire_3_1(in_wire_3_1),
		.in_wire_3_0(in_wire_3_0),
		.config_data(config_data),
		.in_wire_0_0(in_wire_0_0),
		.in_wire_0_1(in_wire_0_1),
		.in_wire_0_2(in_wire_0_2),
		.in_wire_0_3(in_wire_0_3),
		.in_wire_1_1(in_wire_1_1),
		.in_wire_1_0(in_wire_1_0),
		.in_wire_1_3(in_wire_1_3),
		.in_wire_1_2(in_wire_1_2),
		.reset(reset)
	);

	// Set configuration flag
	reg config_en_cb0;
	localparam CONFIG_cb0 = 6;
	always @(*) begin
		if ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_cb0)) begin
			config_en_cb0 = 1'b1;
		end else begin
			config_en_cb0 = 1'b0;
		end
	end



	// Declare module
	connect_box cb0(
		.track6_in(out_wire_0_2),
		.config_data(config_data[2:0]),
		.config_en(config_en_cb0),
		.track3_in(in_wire_0_3),
		.clk(clk),
		.track7_in(out_wire_0_3),
		.track5_in(out_wire_0_1),
		.track0_in(in_wire_0_0),
		.block_out(op_0),
		.track4_in(out_wire_0_0),
		.track2_in(in_wire_0_2),
		.track1_in(in_wire_0_1)
	);

	// Set configuration flag
	reg config_en_cb1;
	localparam CONFIG_cb1 = 5;
	always @(*) begin
		if ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_cb1)) begin
			config_en_cb1 = 1'b1;
		end else begin
			config_en_cb1 = 1'b0;
		end
	end



	// Declare module
	connect_box cb1(
		.track6_in(out_wire_1_2),
		.config_data(config_data[2:0]),
		.config_en(config_en_cb1),
		.track3_in(in_wire_1_3),
		.clk(clk),
		.track7_in(out_wire_1_3),
		.track5_in(out_wire_1_1),
		.track0_in(in_wire_1_0),
		.block_out(op_1),
		.track4_in(out_wire_1_0),
		.track2_in(in_wire_1_2),
		.track1_in(in_wire_1_1)
	);



endmodule
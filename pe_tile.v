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


	localparam CONFIG_SB = 7;

	wire op_0;
	wire op_1;
	wire pe_output;

	// Switch box config
	reg config_en_sb;

	always @(*) begin
		if ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_SB)) begin
			config_en_sb = 1'b1;
		end
	end

	connect_box cb0(
		.track0_in(in_wire_0_0),
		.track1_in(in_wire_0_1),
		.track2_in(in_wire_0_2),
		.track3_in(in_wire_0_3),
		.block_out(op_0),
		.config_en(1'b0),
		.config_data(2'b0),
		.clk(clk)
	);

	connect_box cb1(
		.track0_in(in_wire_1_0),
		.track1_in(in_wire_1_1),
		.track2_in(in_wire_1_2),
		.track3_in(in_wire_1_3),
		.block_out(op_1),
		.config_en(1'b0),
		.config_data(2'b0),
		.clk(clk)
	);

	switch_box sb(
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
		.out_wire_2_3(out_wire_2_3),
		.out_wire_3_0(out_wire_3_0),
		.out_wire_3_1(out_wire_3_1),
		.out_wire_3_2(out_wire_3_2),
		.out_wire_3_3(out_wire_3_3),
		.pe_output_0(pe_output),
		.config_data(config_data),
		.config_en(1'b0),
		.clk(clk),
		.reset(reset)
		);

	clb compute_block(
		.in0(op_0),
		.in1(op_1),
		.clk(clk),
		.config_enable(config_en_sb),
		.config_data(2'b0),
		.out(pe_output)
		);



endmodule
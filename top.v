`include "pe_tile"
`include "io1in_pad"
`include "io1out_pad"


module top(
	input clk,
	input reset,
	input [31:0] config_addr,
	input [31:0] config_data,
	input in_wire_0,
	input in_wire_1,
	output out_wire_0,
	output out_wire_1
	);

	wire input_to_grid_0;
	wire input_to_grid_1;


	wire grid_to_output_0;
	wire grid_to_output_1;


	io1in_pad in_pad_0(
		.clk(clk),
		.top_pin(in_wire_0),
		.pin(input_to_grid_0)
	);

	io1in_pad in_pad_1(
		.clk(clk),
		.top_pin(in_wire_1),
		.pin(input_to_grid_1)
	);

	io1out_pad out_pad_0(
		.clk(clk),
		.top_pin(out_wire_0),
		.pin(grid_to_output_0)
	);

	io1out_pad out_pad_1(
		.clk(clk),
		.top_pin(out_wire_1),
		.pin(grid_to_output_1)
	);

	// PE tile grid
	pe_tile pe_tile_0_0(
		.in_wire_3_0(input_to_grid_0),
		.out_wire_1_0(pe_tile_1_0.in_wire_3_0),
		.out_wire_1_1(pe_tile_1_0.in_wire_3_1),
		.out_wire_1_2(pe_tile_1_0.in_wire_3_2),
		.out_wire_1_3(pe_tile_1_0.in_wire_3_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(1)
	);

	pe_tile pe_tile_0_1(
		.in_wire_3_0(input_to_grid_1),
		.out_wire_1_0(pe_tile_1_1.in_wire_3_0),
		.out_wire_1_1(pe_tile_1_1.in_wire_3_1),
		.out_wire_1_2(pe_tile_1_1.in_wire_3_2),
		.out_wire_1_3(pe_tile_1_1.in_wire_3_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(2)
	);

	pe_tile pe_tile_1_0(
		.out_wire_1_0(grid_to_output_0),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(3)
	);

	pe_tile pe_tile_1_1(
		.out_wire_1_0(grid_to_output_1),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(4)
	);



endmodule
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


	// 
	// input pads
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

	// output pads
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
	// Vertical wires
	wire vertical_tile_0_0_to_tile_1_0_0;
	wire vertical_tile_0_0_to_tile_1_0_1;
	wire vertical_tile_0_0_to_tile_1_0_2;
	wire vertical_tile_0_0_to_tile_1_0_3;
	wire vertical_tile_1_0_to_tile_0_0_0;
	wire vertical_tile_1_0_to_tile_0_0_1;
	wire vertical_tile_1_0_to_tile_0_0_2;
	wire vertical_tile_1_0_to_tile_0_0_3;

	wire vertical_tile_0_1_to_tile_1_1_0;
	wire vertical_tile_0_1_to_tile_1_1_1;
	wire vertical_tile_0_1_to_tile_1_1_2;
	wire vertical_tile_0_1_to_tile_1_1_3;
	wire vertical_tile_1_1_to_tile_0_1_0;
	wire vertical_tile_1_1_to_tile_0_1_1;
	wire vertical_tile_1_1_to_tile_0_1_2;
	wire vertical_tile_1_1_to_tile_0_1_3;

	// Horizontal wires
	wire horizontal_tile_0_0_to_tile_0_1_0;
	wire horizontal_tile_0_0_to_tile_0_1_1;
	wire horizontal_tile_0_0_to_tile_0_1_2;
	wire horizontal_tile_0_0_to_tile_0_1_3;
	wire horizontal_tile_0_1_to_tile_0_0_0;
	wire horizontal_tile_0_1_to_tile_0_0_1;
	wire horizontal_tile_0_1_to_tile_0_0_2;
	wire horizontal_tile_0_1_to_tile_0_0_3;

	wire horizontal_tile_1_0_to_tile_1_1_0;
	wire horizontal_tile_1_0_to_tile_1_1_1;
	wire horizontal_tile_1_0_to_tile_1_1_2;
	wire horizontal_tile_1_0_to_tile_1_1_3;
	wire horizontal_tile_1_1_to_tile_1_0_0;
	wire horizontal_tile_1_1_to_tile_1_0_1;
	wire horizontal_tile_1_1_to_tile_1_0_2;
	wire horizontal_tile_1_1_to_tile_1_0_3;

	// Tile declarations
	pe_tile pe_tile_0_0(
		.in_wire_3_0(input_to_grid_0),
		.out_wire_1_0(vertical_tile_0_0_to_tile_1_0_0),
		.out_wire_1_1(vertical_tile_0_0_to_tile_1_0_1),
		.out_wire_1_2(vertical_tile_0_0_to_tile_1_0_2),
		.out_wire_1_3(vertical_tile_0_0_to_tile_1_0_3),
		.in_wire_1_0(vertical_tile_1_0_to_tile_0_0_0),
		.in_wire_1_1(vertical_tile_1_0_to_tile_0_0_1),
		.in_wire_1_2(vertical_tile_1_0_to_tile_0_0_2),
		.in_wire_1_3(vertical_tile_1_0_to_tile_0_0_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(1)
	);

	pe_tile pe_tile_0_1(
		.in_wire_3_0(input_to_grid_1),
		.out_wire_1_0(vertical_tile_0_1_to_tile_1_1_0),
		.out_wire_1_1(vertical_tile_0_1_to_tile_1_1_1),
		.out_wire_1_2(vertical_tile_0_1_to_tile_1_1_2),
		.out_wire_1_3(vertical_tile_0_1_to_tile_1_1_3),
		.in_wire_1_0(vertical_tile_1_1_to_tile_0_1_0),
		.in_wire_1_1(vertical_tile_1_1_to_tile_0_1_1),
		.in_wire_1_2(vertical_tile_1_1_to_tile_0_1_2),
		.in_wire_1_3(vertical_tile_1_1_to_tile_0_1_3),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(2)
	);

	pe_tile pe_tile_1_0(
		.out_wire_3_0(vertical_tile_1_0_to_tile_0_0_0),
		.out_wire_3_1(vertical_tile_1_0_to_tile_0_0_1),
		.out_wire_3_2(vertical_tile_1_0_to_tile_0_0_2),
		.out_wire_3_3(vertical_tile_1_0_to_tile_0_0_3),
		.in_wire_3_0(vertical_tile_0_0_to_tile_1_0_0),
		.in_wire_3_1(vertical_tile_0_0_to_tile_1_0_1),
		.in_wire_3_2(vertical_tile_0_0_to_tile_1_0_2),
		.in_wire_3_3(vertical_tile_0_0_to_tile_1_0_3),
		.out_wire_1_0(grid_to_output_0),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(3)
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
		.out_wire_1_0(grid_to_output_1),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(4)
	);



endmodule
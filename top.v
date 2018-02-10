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

	wire input_to_grid_0;
	wire input_to_grid_1;
	wire input_to_grid_2;


	wire grid_to_output_0;
	wire grid_to_output_1;
	wire grid_to_output_2;


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

	io1in_pad in_pad_2(
		.clk(clk),
		.top_pin(in_wire_2),
		.pin(input_to_grid_2)
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

	io1out_pad out_pad_2(
		.clk(clk),
		.top_pin(out_wire_2),
		.pin(grid_to_output_2)
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

	wire vertical_tile_0_2_to_tile_1_2_0;
	wire vertical_tile_0_2_to_tile_1_2_1;
	wire vertical_tile_0_2_to_tile_1_2_2;
	wire vertical_tile_0_2_to_tile_1_2_3;
	wire vertical_tile_1_2_to_tile_0_2_0;
	wire vertical_tile_1_2_to_tile_0_2_1;
	wire vertical_tile_1_2_to_tile_0_2_2;
	wire vertical_tile_1_2_to_tile_0_2_3;

	wire vertical_tile_1_0_to_tile_2_0_0;
	wire vertical_tile_1_0_to_tile_2_0_1;
	wire vertical_tile_1_0_to_tile_2_0_2;
	wire vertical_tile_1_0_to_tile_2_0_3;
	wire vertical_tile_2_0_to_tile_1_0_0;
	wire vertical_tile_2_0_to_tile_1_0_1;
	wire vertical_tile_2_0_to_tile_1_0_2;
	wire vertical_tile_2_0_to_tile_1_0_3;

	wire vertical_tile_1_1_to_tile_2_1_0;
	wire vertical_tile_1_1_to_tile_2_1_1;
	wire vertical_tile_1_1_to_tile_2_1_2;
	wire vertical_tile_1_1_to_tile_2_1_3;
	wire vertical_tile_2_1_to_tile_1_1_0;
	wire vertical_tile_2_1_to_tile_1_1_1;
	wire vertical_tile_2_1_to_tile_1_1_2;
	wire vertical_tile_2_1_to_tile_1_1_3;

	wire vertical_tile_1_2_to_tile_2_2_0;
	wire vertical_tile_1_2_to_tile_2_2_1;
	wire vertical_tile_1_2_to_tile_2_2_2;
	wire vertical_tile_1_2_to_tile_2_2_3;
	wire vertical_tile_2_2_to_tile_1_2_0;
	wire vertical_tile_2_2_to_tile_1_2_1;
	wire vertical_tile_2_2_to_tile_1_2_2;
	wire vertical_tile_2_2_to_tile_1_2_3;

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

	wire horizontal_tile_2_0_to_tile_2_1_0;
	wire horizontal_tile_2_0_to_tile_2_1_1;
	wire horizontal_tile_2_0_to_tile_2_1_2;
	wire horizontal_tile_2_0_to_tile_2_1_3;
	wire horizontal_tile_2_1_to_tile_2_0_0;
	wire horizontal_tile_2_1_to_tile_2_0_1;
	wire horizontal_tile_2_1_to_tile_2_0_2;
	wire horizontal_tile_2_1_to_tile_2_0_3;

	wire horizontal_tile_0_1_to_tile_0_2_0;
	wire horizontal_tile_0_1_to_tile_0_2_1;
	wire horizontal_tile_0_1_to_tile_0_2_2;
	wire horizontal_tile_0_1_to_tile_0_2_3;
	wire horizontal_tile_0_2_to_tile_0_1_0;
	wire horizontal_tile_0_2_to_tile_0_1_1;
	wire horizontal_tile_0_2_to_tile_0_1_2;
	wire horizontal_tile_0_2_to_tile_0_1_3;

	wire horizontal_tile_1_1_to_tile_1_2_0;
	wire horizontal_tile_1_1_to_tile_1_2_1;
	wire horizontal_tile_1_1_to_tile_1_2_2;
	wire horizontal_tile_1_1_to_tile_1_2_3;
	wire horizontal_tile_1_2_to_tile_1_1_0;
	wire horizontal_tile_1_2_to_tile_1_1_1;
	wire horizontal_tile_1_2_to_tile_1_1_2;
	wire horizontal_tile_1_2_to_tile_1_1_3;

	wire horizontal_tile_2_1_to_tile_2_2_0;
	wire horizontal_tile_2_1_to_tile_2_2_1;
	wire horizontal_tile_2_1_to_tile_2_2_2;
	wire horizontal_tile_2_1_to_tile_2_2_3;
	wire horizontal_tile_2_2_to_tile_2_1_0;
	wire horizontal_tile_2_2_to_tile_2_1_1;
	wire horizontal_tile_2_2_to_tile_2_1_2;
	wire horizontal_tile_2_2_to_tile_2_1_3;

	// Tile declarations
	pe_tile pe_tile_0_0(
		.in_wire_3_0(input_to_grid_0),
		.in_wire_3_1(1'b0),
		.in_wire_3_2(1'b0),
		.in_wire_3_3(1'b0),
		.out_wire_1_0(vertical_tile_0_0_to_tile_1_0_0),
		.out_wire_1_1(vertical_tile_0_0_to_tile_1_0_1),
		.out_wire_1_2(vertical_tile_0_0_to_tile_1_0_2),
		.out_wire_1_3(vertical_tile_0_0_to_tile_1_0_3),
		.in_wire_1_0(vertical_tile_1_0_to_tile_0_0_0),
		.in_wire_1_1(vertical_tile_1_0_to_tile_0_0_1),
		.in_wire_1_2(vertical_tile_1_0_to_tile_0_0_2),
		.in_wire_1_3(vertical_tile_1_0_to_tile_0_0_3),
		.in_wire_2_0(1'b0),
		.in_wire_2_1(1'b0),
		.in_wire_2_2(1'b0),
		.in_wire_2_3(1'b0),
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
		.tile_id(1)
	);

	pe_tile_top pe_tile_0_1(
		.in_wire_3_0(input_to_grid_1),
		.in_wire_3_1(1'b0),
		.in_wire_3_2(1'b0),
		.in_wire_3_3(1'b0),
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
		.tile_id(2)
	);

	pe_tile pe_tile_0_2(
		.in_wire_3_0(input_to_grid_2),
		.in_wire_3_1(1'b0),
		.in_wire_3_2(1'b0),
		.in_wire_3_3(1'b0),
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
		.in_wire_0_0(1'b0),
		.in_wire_0_1(1'b0),
		.in_wire_0_2(1'b0),
		.in_wire_0_3(1'b0),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(3)
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
		.in_wire_2_0(1'b0),
		.in_wire_2_1(1'b0),
		.in_wire_2_2(1'b0),
		.in_wire_2_3(1'b0),
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
		.tile_id(4)
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
		.tile_id(5)
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
		.in_wire_0_0(1'b0),
		.in_wire_0_1(1'b0),
		.in_wire_0_2(1'b0),
		.in_wire_0_3(1'b0),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(6)
	);

	pe_tile pe_tile_2_0(
		.out_wire_3_0(vertical_tile_2_0_to_tile_1_0_0),
		.out_wire_3_1(vertical_tile_2_0_to_tile_1_0_1),
		.out_wire_3_2(vertical_tile_2_0_to_tile_1_0_2),
		.out_wire_3_3(vertical_tile_2_0_to_tile_1_0_3),
		.in_wire_3_0(vertical_tile_1_0_to_tile_2_0_0),
		.in_wire_3_1(vertical_tile_1_0_to_tile_2_0_1),
		.in_wire_3_2(vertical_tile_1_0_to_tile_2_0_2),
		.in_wire_3_3(vertical_tile_1_0_to_tile_2_0_3),
		.out_wire_1_0(grid_to_output_0),
		.in_wire_1_0(1'b0),
		.in_wire_1_1(1'b0),
		.in_wire_1_2(1'b0),
		.in_wire_1_3(1'b0),
		.in_wire_2_0(1'b0),
		.in_wire_2_1(1'b0),
		.in_wire_2_2(1'b0),
		.in_wire_2_3(1'b0),
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
		.tile_id(7)
	);

	pe_tile pe_tile_2_1(
		.out_wire_3_0(vertical_tile_2_1_to_tile_1_1_0),
		.out_wire_3_1(vertical_tile_2_1_to_tile_1_1_1),
		.out_wire_3_2(vertical_tile_2_1_to_tile_1_1_2),
		.out_wire_3_3(vertical_tile_2_1_to_tile_1_1_3),
		.in_wire_3_0(vertical_tile_1_1_to_tile_2_1_0),
		.in_wire_3_1(vertical_tile_1_1_to_tile_2_1_1),
		.in_wire_3_2(vertical_tile_1_1_to_tile_2_1_2),
		.in_wire_3_3(vertical_tile_1_1_to_tile_2_1_3),
		.out_wire_1_0(grid_to_output_1),
		.in_wire_1_0(1'b0),
		.in_wire_1_1(1'b0),
		.in_wire_1_2(1'b0),
		.in_wire_1_3(1'b0),
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
		.tile_id(8)
	);

	pe_tile pe_tile_2_2(
		.out_wire_3_0(vertical_tile_2_2_to_tile_1_2_0),
		.out_wire_3_1(vertical_tile_2_2_to_tile_1_2_1),
		.out_wire_3_2(vertical_tile_2_2_to_tile_1_2_2),
		.out_wire_3_3(vertical_tile_2_2_to_tile_1_2_3),
		.in_wire_3_0(vertical_tile_1_2_to_tile_2_2_0),
		.in_wire_3_1(vertical_tile_1_2_to_tile_2_2_1),
		.in_wire_3_2(vertical_tile_1_2_to_tile_2_2_2),
		.in_wire_3_3(vertical_tile_1_2_to_tile_2_2_3),
		.out_wire_1_0(grid_to_output_2),
		.in_wire_1_0(1'b0),
		.in_wire_1_1(1'b0),
		.in_wire_1_2(1'b0),
		.in_wire_1_3(1'b0),
		.out_wire_2_0(horizontal_tile_2_2_to_tile_2_1_0),
		.out_wire_2_1(horizontal_tile_2_2_to_tile_2_1_1),
		.out_wire_2_2(horizontal_tile_2_2_to_tile_2_1_2),
		.out_wire_2_3(horizontal_tile_2_2_to_tile_2_1_3),
		.in_wire_2_0(horizontal_tile_2_1_to_tile_2_2_0),
		.in_wire_2_1(horizontal_tile_2_1_to_tile_2_2_1),
		.in_wire_2_2(horizontal_tile_2_1_to_tile_2_2_2),
		.in_wire_2_3(horizontal_tile_2_1_to_tile_2_2_3),
		.in_wire_0_0(1'b0),
		.in_wire_0_1(1'b0),
		.in_wire_0_2(1'b0),
		.in_wire_0_3(1'b0),
		.clk(clk),
		.reset(reset),
		.config_addr(config_addr),
		.config_data(config_data),
		.tile_id(9)
	);



endmodule
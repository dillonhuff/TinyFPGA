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
	input in_wire_2,
	input in_wire_3,
	input in_wire_4,
	input in_wire_5,
	input in_wire_6,
	input in_wire_7,
	input in_wire_8,
	input in_wire_9,
	input in_wire_10,
	input in_wire_11,
	input in_wire_12,
	input in_wire_13,
	input in_wire_14,
	input in_wire_15,
	output out_wire_0,
	output out_wire_1,
	output out_wire_2,
	output out_wire_3,
	output out_wire_4,
	output out_wire_5,
	output out_wire_6,
	output out_wire_7,
	output out_wire_8,
	output out_wire_9,
	output out_wire_10,
	output out_wire_11,
	output out_wire_12,
	output out_wire_13,
	output out_wire_14,
	output out_wire_15
	);

	wire input_to_grid_0;
	wire input_to_grid_1;
	wire input_to_grid_2;
	wire input_to_grid_3;
	wire input_to_grid_4;
	wire input_to_grid_5;
	wire input_to_grid_6;
	wire input_to_grid_7;
	wire input_to_grid_8;
	wire input_to_grid_9;
	wire input_to_grid_10;
	wire input_to_grid_11;
	wire input_to_grid_12;
	wire input_to_grid_13;
	wire input_to_grid_14;
	wire input_to_grid_15;


	wire grid_to_output_0;
	wire grid_to_output_1;
	wire grid_to_output_2;
	wire grid_to_output_3;
	wire grid_to_output_4;
	wire grid_to_output_5;
	wire grid_to_output_6;
	wire grid_to_output_7;
	wire grid_to_output_8;
	wire grid_to_output_9;
	wire grid_to_output_10;
	wire grid_to_output_11;
	wire grid_to_output_12;
	wire grid_to_output_13;
	wire grid_to_output_14;
	wire grid_to_output_15;


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

	io1in_pad in_pad_3(
		.clk(clk),
		.top_pin(in_wire_3),
		.pin(input_to_grid_3)
	);

	io1in_pad in_pad_4(
		.clk(clk),
		.top_pin(in_wire_4),
		.pin(input_to_grid_4)
	);

	io1in_pad in_pad_5(
		.clk(clk),
		.top_pin(in_wire_5),
		.pin(input_to_grid_5)
	);

	io1in_pad in_pad_6(
		.clk(clk),
		.top_pin(in_wire_6),
		.pin(input_to_grid_6)
	);

	io1in_pad in_pad_7(
		.clk(clk),
		.top_pin(in_wire_7),
		.pin(input_to_grid_7)
	);

	io1in_pad in_pad_8(
		.clk(clk),
		.top_pin(in_wire_8),
		.pin(input_to_grid_8)
	);

	io1in_pad in_pad_9(
		.clk(clk),
		.top_pin(in_wire_9),
		.pin(input_to_grid_9)
	);

	io1in_pad in_pad_10(
		.clk(clk),
		.top_pin(in_wire_10),
		.pin(input_to_grid_10)
	);

	io1in_pad in_pad_11(
		.clk(clk),
		.top_pin(in_wire_11),
		.pin(input_to_grid_11)
	);

	io1in_pad in_pad_12(
		.clk(clk),
		.top_pin(in_wire_12),
		.pin(input_to_grid_12)
	);

	io1in_pad in_pad_13(
		.clk(clk),
		.top_pin(in_wire_13),
		.pin(input_to_grid_13)
	);

	io1in_pad in_pad_14(
		.clk(clk),
		.top_pin(in_wire_14),
		.pin(input_to_grid_14)
	);

	io1in_pad in_pad_15(
		.clk(clk),
		.top_pin(in_wire_15),
		.pin(input_to_grid_15)
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

	io1out_pad out_pad_2(
		.clk(clk),
		.top_pin(out_wire_2),
		.pin(grid_to_output_2)
	);

	io1out_pad out_pad_3(
		.clk(clk),
		.top_pin(out_wire_3),
		.pin(grid_to_output_3)
	);

	io1out_pad out_pad_4(
		.clk(clk),
		.top_pin(out_wire_4),
		.pin(grid_to_output_4)
	);

	io1out_pad out_pad_5(
		.clk(clk),
		.top_pin(out_wire_5),
		.pin(grid_to_output_5)
	);

	io1out_pad out_pad_6(
		.clk(clk),
		.top_pin(out_wire_6),
		.pin(grid_to_output_6)
	);

	io1out_pad out_pad_7(
		.clk(clk),
		.top_pin(out_wire_7),
		.pin(grid_to_output_7)
	);

	io1out_pad out_pad_8(
		.clk(clk),
		.top_pin(out_wire_8),
		.pin(grid_to_output_8)
	);

	io1out_pad out_pad_9(
		.clk(clk),
		.top_pin(out_wire_9),
		.pin(grid_to_output_9)
	);

	io1out_pad out_pad_10(
		.clk(clk),
		.top_pin(out_wire_10),
		.pin(grid_to_output_10)
	);

	io1out_pad out_pad_11(
		.clk(clk),
		.top_pin(out_wire_11),
		.pin(grid_to_output_11)
	);

	io1out_pad out_pad_12(
		.clk(clk),
		.top_pin(out_wire_12),
		.pin(grid_to_output_12)
	);

	io1out_pad out_pad_13(
		.clk(clk),
		.top_pin(out_wire_13),
		.pin(grid_to_output_13)
	);

	io1out_pad out_pad_14(
		.clk(clk),
		.top_pin(out_wire_14),
		.pin(grid_to_output_14)
	);

	io1out_pad out_pad_15(
		.clk(clk),
		.top_pin(out_wire_15),
		.pin(grid_to_output_15)
	);



endmodule
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

	io1in_pad in_pad_0(
		.clk(clk),
		.top_pin(in_wire_0)
	);

	io1in_pad in_pad_1(
		.clk(clk),
		.top_pin(in_wire_1)
	);

	io1in_pad in_pad_2(
		.clk(clk),
		.top_pin(in_wire_2)
	);

	io1in_pad in_pad_3(
		.clk(clk),
		.top_pin(in_wire_3)
	);

	io1in_pad in_pad_4(
		.clk(clk),
		.top_pin(in_wire_4)
	);

	io1in_pad in_pad_5(
		.clk(clk),
		.top_pin(in_wire_5)
	);

	io1in_pad in_pad_6(
		.clk(clk),
		.top_pin(in_wire_6)
	);

	io1in_pad in_pad_7(
		.clk(clk),
		.top_pin(in_wire_7)
	);

	io1in_pad in_pad_8(
		.clk(clk),
		.top_pin(in_wire_8)
	);

	io1in_pad in_pad_9(
		.clk(clk),
		.top_pin(in_wire_9)
	);

	io1in_pad in_pad_10(
		.clk(clk),
		.top_pin(in_wire_10)
	);

	io1in_pad in_pad_11(
		.clk(clk),
		.top_pin(in_wire_11)
	);

	io1in_pad in_pad_12(
		.clk(clk),
		.top_pin(in_wire_12)
	);

	io1in_pad in_pad_13(
		.clk(clk),
		.top_pin(in_wire_13)
	);

	io1in_pad in_pad_14(
		.clk(clk),
		.top_pin(in_wire_14)
	);

	io1in_pad in_pad_15(
		.clk(clk),
		.top_pin(in_wire_15)
	);

	io1out_pad out_pad_0(
		.clk(clk),
		.top_pin(out_wire_0)
	);

	io1out_pad out_pad_1(
		.clk(clk),
		.top_pin(out_wire_1)
	);

	io1out_pad out_pad_2(
		.clk(clk),
		.top_pin(out_wire_2)
	);

	io1out_pad out_pad_3(
		.clk(clk),
		.top_pin(out_wire_3)
	);

	io1out_pad out_pad_4(
		.clk(clk),
		.top_pin(out_wire_4)
	);

	io1out_pad out_pad_5(
		.clk(clk),
		.top_pin(out_wire_5)
	);

	io1out_pad out_pad_6(
		.clk(clk),
		.top_pin(out_wire_6)
	);

	io1out_pad out_pad_7(
		.clk(clk),
		.top_pin(out_wire_7)
	);

	io1out_pad out_pad_8(
		.clk(clk),
		.top_pin(out_wire_8)
	);

	io1out_pad out_pad_9(
		.clk(clk),
		.top_pin(out_wire_9)
	);

	io1out_pad out_pad_10(
		.clk(clk),
		.top_pin(out_wire_10)
	);

	io1out_pad out_pad_11(
		.clk(clk),
		.top_pin(out_wire_11)
	);

	io1out_pad out_pad_12(
		.clk(clk),
		.top_pin(out_wire_12)
	);

	io1out_pad out_pad_13(
		.clk(clk),
		.top_pin(out_wire_13)
	);

	io1out_pad out_pad_14(
		.clk(clk),
		.top_pin(out_wire_14)
	);

	io1out_pad out_pad_15(
		.clk(clk),
		.top_pin(out_wire_15)
	);



endmodule
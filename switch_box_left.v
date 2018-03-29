

module switch_box_left(
	input in_wire_0_0,
	input in_wire_0_1,
	input in_wire_0_2,
	input in_wire_0_3,
	input in_wire_2_2,
	input in_wire_2_3,
	input in_wire_2_0,
	input in_wire_2_1,
	input in_wire_1_1,
	input in_wire_1_0,
	input in_wire_1_3,
	input in_wire_1_2,
	input in_wire_3_3,
	input in_wire_3_2,
	input in_wire_3_1,
	input in_wire_3_0,
	output out_wire_0_0,
	output out_wire_0_1,
	output out_wire_0_2,
	output out_wire_0_3,
	output out_wire_1_0,
	output out_wire_1_1,
	output out_wire_1_2,
	output out_wire_1_3,
	output out_wire_3_0,
	output out_wire_3_1,
	output out_wire_3_2,
	output out_wire_3_3,
	input pe_output_0,
	input [31:0] config_data,
	input config_en,
	input clk,
	input reset
	);

	// Internal wires
	wire [2 - 1 : 0] wire_8;
	wire [2 - 1 : 0] wire_9;
	wire [2 - 1 : 0] wire_0;
	wire [2 - 1 : 0] wire_1;
	wire [2 - 1 : 0] wire_2;
	wire [2 - 1 : 0] wire_3;
	wire [2 - 1 : 0] wire_4;
	wire [2 - 1 : 0] wire_5;
	wire [2 - 1 : 0] wire_6;
	wire [2 - 1 : 0] wire_7;
	wire [32 - 1 : 0] config_data_reg;
	wire [2 - 1 : 0] wire_10;
	wire [2 - 1 : 0] wire_11;
	// End of internal wires

	reg [1 - 1 : 0] out_wire_1_2_i;
	reg [1 - 1 : 0] out_wire_3_1_i;
	reg [1 - 1 : 0] out_wire_1_1_i;
	reg [1 - 1 : 0] out_wire_0_1_i;
	reg [1 - 1 : 0] out_wire_1_3_i;
	reg [1 - 1 : 0] out_wire_0_3_i;
	reg [1 - 1 : 0] out_wire_3_2_i;
	reg [1 - 1 : 0] out_wire_0_0_i;
	reg [1 - 1 : 0] out_wire_0_2_i;
	reg [1 - 1 : 0] out_wire_3_3_i;
	reg [1 - 1 : 0] out_wire_3_0_i;
	reg [1 - 1 : 0] out_wire_1_0_i;
	// End of internal regs

	slice_mod #(.width(32), .end_ind(3), .start_ind(2))  wire_1_slice(
	);

	slice_mod #(.width(32), .end_ind(7), .start_ind(6))  wire_3_slice(
	);

	sb_config #(.width(32))  configuration(
		.config_data(config_data_reg),
		.clk(clk),
		.reset(reset),
		.config_en(config_en)
	);

	slice_mod #(.width(32), .end_ind(13), .start_ind(12))  wire_6_slice(
	);

	slice_mod #(.width(32), .end_ind(31), .start_ind(30))  wire_11_slice(
	);

	slice_mod #(.width(32), .end_ind(15), .start_ind(14))  wire_7_slice(
	);

	slice_mod #(.width(32), .end_ind(25), .start_ind(24))  wire_8_slice(
	);

	slice_mod #(.width(32), .end_ind(29), .start_ind(28))  wire_10_slice(
	);

	slice_mod #(.width(32), .end_ind(9), .start_ind(8))  wire_4_slice(
	);

	slice_mod #(.width(32), .end_ind(27), .start_ind(26))  wire_9_slice(
	);

	slice_mod #(.width(32), .end_ind(1), .start_ind(0))  wire_0_slice(
	);

	slice_mod #(.width(32), .end_ind(5), .start_ind(4))  wire_2_slice(
	);

	slice_mod #(.width(32), .end_ind(11), .start_ind(10))  wire_5_slice(
	);



endmodule
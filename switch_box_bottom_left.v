

module switch_box_bottom_left(
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
	wire [32 - 1 : 0] config_data_reg;
	// End of internal wires
	sb_config #(.width(32))  configuration(
		.config_data(config_data_reg),
		.clk(clk),
		.reset(reset),
		.config_en(config_en)
	);



endmodule
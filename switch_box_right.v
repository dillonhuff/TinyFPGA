

module switch_box_right(
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
	output out_wire_2_0,
	output out_wire_2_1,
	output out_wire_2_2,
	output out_wire_2_3,
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
	reg [1 - 1 : 0] slice_out_wire_3_0_sel_out;
	reg [1 - 1 : 0] slice_out_wire_2_2_sel_out;
	reg [1 - 1 : 0] slice_out_wire_2_0_sel_out;
	reg [1 - 1 : 0] slice_out_wire_2_3_sel_out;
	reg [1 - 1 : 0] slice_out_wire_3_1_sel_out;
	reg [1 - 1 : 0] slice_out_wire_3_2_sel_out;
	reg [1 - 1 : 0] slice_out_wire_3_3_sel_out;
	reg [1 - 1 : 0] slice_out_wire_0_3_sel_out;
	reg [1 - 1 : 0] slice_out_wire_0_2_sel_out;
	reg [1 - 1 : 0] slice_out_wire_0_1_sel_out;
	reg [1 - 1 : 0] slice_out_wire_0_0_sel_out;
	reg [1 - 1 : 0] slice_out_wire_2_1_sel_out;
	reg [1 - 1 : 0] slice_out_wire_1_1_sel_out;
	reg [1 - 1 : 0] slice_out_wire_1_2_sel_out;
	reg [1 - 1 : 0] slice_out_wire_1_3_sel_out;
	reg [1 - 1 : 0] slice_out_wire_1_0_sel_out;
	reg [1 - 1 : 0] config_data_reg;
	// End of wire declarations

	slice_mod #(.width(32), .end_ind(23), .start_ind(22))  slice_out_wire_2_3_slice(
		.in(config_data_reg),
		.out(slice_out_wire_2_3_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_0_1_mux_4(
		.out(out_wire_0_1),
		.sel(slice_out_wire_0_1_sel_out),
		.in0(in_wire_1_1),
		.in1(in_wire_2_2),
		.in2(in_wire_3_3),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_2_1_mux_4(
		.out(out_wire_2_1),
		.sel(slice_out_wire_2_1_sel_out),
		.in0(in_wire_3_3),
		.in1(in_wire_0_0),
		.in2(in_wire_1_1),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_2_2_mux_4(
		.out(out_wire_2_2),
		.sel(slice_out_wire_2_2_sel_out),
		.in0(in_wire_3_0),
		.in1(in_wire_0_1),
		.in2(in_wire_1_2),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(7), .start_ind(6))  slice_out_wire_0_3_slice(
		.in(config_data_reg),
		.out(slice_out_wire_0_3_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_1_0_mux_4(
		.out(out_wire_1_0),
		.sel(slice_out_wire_1_0_sel_out),
		.in0(in_wire_2_1),
		.in1(in_wire_3_2),
		.in2(in_wire_0_3),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(3), .start_ind(2))  slice_out_wire_0_1_slice(
		.in(config_data_reg),
		.out(slice_out_wire_0_1_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_1_1_mux_4(
		.out(out_wire_1_1),
		.sel(slice_out_wire_1_1_sel_out),
		.in0(in_wire_2_2),
		.in1(in_wire_3_3),
		.in2(in_wire_0_0),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(9), .start_ind(8))  slice_out_wire_1_0_slice(
		.in(config_data_reg),
		.out(slice_out_wire_1_0_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_0_3_mux_4(
		.out(out_wire_0_3),
		.sel(slice_out_wire_0_3_sel_out),
		.in0(in_wire_1_3),
		.in1(in_wire_2_0),
		.in2(in_wire_3_1),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(21), .start_ind(20))  slice_out_wire_2_2_slice(
		.in(config_data_reg),
		.out(slice_out_wire_2_2_sel_out)
	);

	slice_mod #(.width(32), .end_ind(11), .start_ind(10))  slice_out_wire_1_1_slice(
		.in(config_data_reg),
		.out(slice_out_wire_1_1_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_3_2_mux_4(
		.out(out_wire_3_2),
		.sel(slice_out_wire_3_2_sel_out),
		.in0(in_wire_0_1),
		.in1(in_wire_1_2),
		.in2(in_wire_2_3),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_3_0_mux_4(
		.out(out_wire_3_0),
		.sel(slice_out_wire_3_0_sel_out),
		.in0(in_wire_0_3),
		.in1(in_wire_1_0),
		.in2(in_wire_2_1),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(25), .start_ind(24))  slice_out_wire_3_0_slice(
		.in(config_data_reg),
		.out(slice_out_wire_3_0_sel_out)
	);

	slice_mod #(.width(32), .end_ind(13), .start_ind(12))  slice_out_wire_1_2_slice(
		.in(config_data_reg),
		.out(slice_out_wire_1_2_sel_out)
	);

	slice_mod #(.width(32), .end_ind(29), .start_ind(28))  slice_out_wire_3_2_slice(
		.in(config_data_reg),
		.out(slice_out_wire_3_2_sel_out)
	);

	slice_mod #(.width(32), .end_ind(27), .start_ind(26))  slice_out_wire_3_1_slice(
		.in(config_data_reg),
		.out(slice_out_wire_3_1_sel_out)
	);

	slice_mod #(.width(32), .end_ind(19), .start_ind(18))  slice_out_wire_2_1_slice(
		.in(config_data_reg),
		.out(slice_out_wire_2_1_sel_out)
	);

	slice_mod #(.width(32), .end_ind(1), .start_ind(0))  slice_out_wire_0_0_slice(
		.in(config_data_reg),
		.out(slice_out_wire_0_0_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_3_3_mux_4(
		.out(out_wire_3_3),
		.sel(slice_out_wire_3_3_sel_out),
		.in0(in_wire_0_2),
		.in1(in_wire_1_3),
		.in2(in_wire_2_0),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(17), .start_ind(16))  slice_out_wire_2_0_slice(
		.in(config_data_reg),
		.out(slice_out_wire_2_0_sel_out)
	);

	sb_config #(.width(32))  configuration(
		.config_data(config_data_reg),
		.clk(clk),
		.reset(reset),
		.config_en(config_en)
	);

	slice_mod #(.width(32), .end_ind(31), .start_ind(30))  slice_out_wire_3_3_slice(
		.in(config_data_reg),
		.out(slice_out_wire_3_3_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_0_2_mux_4(
		.out(out_wire_0_2),
		.sel(slice_out_wire_0_2_sel_out),
		.in0(in_wire_1_2),
		.in1(in_wire_2_3),
		.in2(in_wire_3_0),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_2_0_mux_4(
		.out(out_wire_2_0),
		.sel(slice_out_wire_2_0_sel_out),
		.in0(in_wire_3_2),
		.in1(in_wire_0_3),
		.in2(in_wire_1_0),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_2_3_mux_4(
		.out(out_wire_2_3),
		.sel(slice_out_wire_2_3_sel_out),
		.in0(in_wire_3_1),
		.in1(in_wire_0_2),
		.in2(in_wire_1_3),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(15), .start_ind(14))  slice_out_wire_1_3_slice(
		.in(config_data_reg),
		.out(slice_out_wire_1_3_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_1_3_mux_4(
		.out(out_wire_1_3),
		.sel(slice_out_wire_1_3_sel_out),
		.in0(in_wire_2_0),
		.in1(in_wire_3_1),
		.in2(in_wire_0_2),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_1_2_mux_4(
		.out(out_wire_1_2),
		.sel(slice_out_wire_1_2_sel_out),
		.in0(in_wire_2_3),
		.in1(in_wire_3_0),
		.in2(in_wire_0_1),
		.in3(pe_output_0)
	);

	mux_4 #(.width(1))  slice_out_wire_3_1_mux_4(
		.out(out_wire_3_1),
		.sel(slice_out_wire_3_1_sel_out),
		.in0(in_wire_0_0),
		.in1(in_wire_1_1),
		.in2(in_wire_2_2),
		.in3(pe_output_0)
	);

	slice_mod #(.width(32), .end_ind(5), .start_ind(4))  slice_out_wire_0_2_slice(
		.in(config_data_reg),
		.out(slice_out_wire_0_2_sel_out)
	);

	mux_4 #(.width(1))  slice_out_wire_0_0_mux_4(
		.out(out_wire_0_0),
		.sel(slice_out_wire_0_0_sel_out),
		.in0(in_wire_1_0),
		.in1(in_wire_2_1),
		.in2(in_wire_3_2),
		.in3(pe_output_0)
	);



endmodule
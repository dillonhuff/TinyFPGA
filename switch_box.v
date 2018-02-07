module switch_box(
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
	output out_wire_3_3,
	input pe_output_0,
	input [31:0] config_data,
	input config_en,
	input clk,
	input reset
	);

	reg [31:0] config_data_reg;
	always @(posedge clk) begin
		if (reset) begin
			config_data_reg <= 32'b0;
		end else if (config_en) begin
			config_data_reg <= config_data;
		end
	end


	always @(*) begin
		case (config_data_reg[1:0])
			2'd0: out_wire_0_0_i = in_wire_0_0;
			2'd1: out_wire_0_0_i = in_wire_0_0;
			2'd2: out_wire_0_0_i = in_wire_0_0;
			2'd3: out_wire_0_0_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_0_1_i = in_wire_0_0;
			2'd1: out_wire_0_1_i = in_wire_0_0;
			2'd2: out_wire_0_1_i = in_wire_0_0;
			2'd3: out_wire_0_1_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_0_2_i = in_wire_0_0;
			2'd1: out_wire_0_2_i = in_wire_0_0;
			2'd2: out_wire_0_2_i = in_wire_0_0;
			2'd3: out_wire_0_2_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_0_3_i = in_wire_0_0;
			2'd1: out_wire_0_3_i = in_wire_0_0;
			2'd2: out_wire_0_3_i = in_wire_0_0;
			2'd3: out_wire_0_3_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_1_0_i = in_wire_0_0;
			2'd1: out_wire_1_0_i = in_wire_0_0;
			2'd2: out_wire_1_0_i = in_wire_0_0;
			2'd3: out_wire_1_0_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_1_1_i = in_wire_0_0;
			2'd1: out_wire_1_1_i = in_wire_0_0;
			2'd2: out_wire_1_1_i = in_wire_0_0;
			2'd3: out_wire_1_1_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_1_2_i = in_wire_0_0;
			2'd1: out_wire_1_2_i = in_wire_0_0;
			2'd2: out_wire_1_2_i = in_wire_0_0;
			2'd3: out_wire_1_2_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_1_3_i = in_wire_0_0;
			2'd1: out_wire_1_3_i = in_wire_0_0;
			2'd2: out_wire_1_3_i = in_wire_0_0;
			2'd3: out_wire_1_3_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_2_0_i = in_wire_0_0;
			2'd1: out_wire_2_0_i = in_wire_0_0;
			2'd2: out_wire_2_0_i = in_wire_0_0;
			2'd3: out_wire_2_0_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_2_1_i = in_wire_0_0;
			2'd1: out_wire_2_1_i = in_wire_0_0;
			2'd2: out_wire_2_1_i = in_wire_0_0;
			2'd3: out_wire_2_1_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_2_2_i = in_wire_0_0;
			2'd1: out_wire_2_2_i = in_wire_0_0;
			2'd2: out_wire_2_2_i = in_wire_0_0;
			2'd3: out_wire_2_2_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_2_3_i = in_wire_0_0;
			2'd1: out_wire_2_3_i = in_wire_0_0;
			2'd2: out_wire_2_3_i = in_wire_0_0;
			2'd3: out_wire_2_3_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_3_0_i = in_wire_0_0;
			2'd1: out_wire_3_0_i = in_wire_0_0;
			2'd2: out_wire_3_0_i = in_wire_0_0;
			2'd3: out_wire_3_0_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_3_1_i = in_wire_0_0;
			2'd1: out_wire_3_1_i = in_wire_0_0;
			2'd2: out_wire_3_1_i = in_wire_0_0;
			2'd3: out_wire_3_1_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_3_2_i = in_wire_0_0;
			2'd1: out_wire_3_2_i = in_wire_0_0;
			2'd2: out_wire_3_2_i = in_wire_0_0;
			2'd3: out_wire_3_2_i = pe_output_0;
		endcase
		case (config_data_reg[1:0])
			2'd0: out_wire_3_3_i = in_wire_0_0;
			2'd1: out_wire_3_3_i = in_wire_0_0;
			2'd2: out_wire_3_3_i = in_wire_0_0;
			2'd3: out_wire_3_3_i = pe_output_0;
		endcase
	end

endmodule
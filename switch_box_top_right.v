module switch_box_top_right(
	input in_wire_2_2,
	input in_wire_2_3,
	input in_wire_2_0,
	input in_wire_2_1,
	input in_wire_1_1,
	input in_wire_1_0,
	input in_wire_1_3,
	input in_wire_1_2,
	output out_wire_1_0,
	output out_wire_1_1,
	output out_wire_1_2,
	output out_wire_1_3,
	output out_wire_2_0,
	output out_wire_2_1,
	output out_wire_2_2,
	output out_wire_2_3,
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


	reg out_wire_1_0_i;
	reg out_wire_1_1_i;
	reg out_wire_1_2_i;
	reg out_wire_1_3_i;
	reg out_wire_2_0_i;
	reg out_wire_2_1_i;
	reg out_wire_2_2_i;
	reg out_wire_2_3_i;

	always @(*) begin
		case (config_data_reg[9:8])
			2'di: out_wire_1_0_i = n;
			2'di: out_wire_1_0_i = n;
			2'd3: out_wire_1_0_i = pe_output_0;
			default: out_wire_1_0_i = 1'b0;
		endcase
	end

	assign out_wire_1_0 = out_wire_1_0_i;

	always @(*) begin
		case (config_data_reg[11:10])
			2'di: out_wire_1_1_i = n;
			2'di: out_wire_1_1_i = n;
			2'd3: out_wire_1_1_i = pe_output_0;
			default: out_wire_1_1_i = 1'b0;
		endcase
	end

	assign out_wire_1_1 = out_wire_1_1_i;

	always @(*) begin
		case (config_data_reg[13:12])
			2'di: out_wire_1_2_i = n;
			2'di: out_wire_1_2_i = n;
			2'd3: out_wire_1_2_i = pe_output_0;
			default: out_wire_1_2_i = 1'b0;
		endcase
	end

	assign out_wire_1_2 = out_wire_1_2_i;

	always @(*) begin
		case (config_data_reg[15:14])
			2'di: out_wire_1_3_i = n;
			2'di: out_wire_1_3_i = n;
			2'd3: out_wire_1_3_i = pe_output_0;
			default: out_wire_1_3_i = 1'b0;
		endcase
	end

	assign out_wire_1_3 = out_wire_1_3_i;

	always @(*) begin
		case (config_data_reg[17:16])
			2'di: out_wire_2_0_i = n;
			2'di: out_wire_2_0_i = n;
			2'd3: out_wire_2_0_i = pe_output_0;
			default: out_wire_2_0_i = 1'b0;
		endcase
	end

	assign out_wire_2_0 = out_wire_2_0_i;

	always @(*) begin
		case (config_data_reg[19:18])
			2'di: out_wire_2_1_i = n;
			2'di: out_wire_2_1_i = n;
			2'd3: out_wire_2_1_i = pe_output_0;
			default: out_wire_2_1_i = 1'b0;
		endcase
	end

	assign out_wire_2_1 = out_wire_2_1_i;

	always @(*) begin
		case (config_data_reg[21:20])
			2'di: out_wire_2_2_i = n;
			2'di: out_wire_2_2_i = n;
			2'd3: out_wire_2_2_i = pe_output_0;
			default: out_wire_2_2_i = 1'b0;
		endcase
	end

	assign out_wire_2_2 = out_wire_2_2_i;

	always @(*) begin
		case (config_data_reg[23:22])
			2'di: out_wire_2_3_i = n;
			2'di: out_wire_2_3_i = n;
			2'd3: out_wire_2_3_i = pe_output_0;
			default: out_wire_2_3_i = 1'b0;
		endcase
	end

	assign out_wire_2_3 = out_wire_2_3_i;



endmodule
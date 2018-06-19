
//                3
//
// 
//  2        switch_box        0
//
//                
//                1

module switch_box(input clk,
                  input        rst,

                  input        config_en,
                  input [31:0] config_data,

                  input        side_0_track_0_in,
                  input        side_0_track_1_in,
                  input        side_0_track_2_in,
                  input        side_0_track_3_in,

                  input        side_1_track_0_in,
                  input        side_1_track_1_in,
                  input        side_1_track_2_in,
                  input        side_1_track_3_in,

                  input        side_2_track_0_in,
                  input        side_2_track_1_in,
                  input        side_2_track_2_in,
                  input        side_2_track_3_in,

                  input        side_3_track_0_in,
                  input        side_3_track_1_in,
                  input        side_3_track_2_in,
                  input        side_3_track_3_in,

                  input        clb_result,

                  /* verilator lint_off UNOPTFLAT */
                  output       side_0_track_0_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_0_track_1_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_0_track_2_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_0_track_3_out,

                  /* verilator lint_off UNOPTFLAT */
                  output       side_1_track_0_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_1_track_1_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_1_track_2_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_1_track_3_out,

                  /* verilator lint_off UNOPTFLAT */
                  output       side_2_track_0_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_2_track_1_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_2_track_2_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_2_track_3_out,

                  /* verilator lint_off UNOPTFLAT */
                  output       side_3_track_0_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_3_track_1_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_3_track_2_out,
                  /* verilator lint_off UNOPTFLAT */
                  output       side_3_track_3_out

                  );

   // One switch per output track (16 switches), 4 options (2 bits) per switch
   // means 32 bits for the configuration register

   reg [31:0]            config_data_reg;

   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         config_data_reg <= 32'h0;
      end else if (config_en) begin
         $display("config is enabled, config_data = ", config_data);
         config_data_reg <= config_data;
      end

      $display("config_data_reg = %b", config_data_reg);
      
   end

   // Side 0
   always @(*) begin
      case (config_data_reg[1:0])
        2'b00: side_0_track_0_out = clb_result;
        2'b01: side_0_track_0_out = side_1_track_0_in;
        2'b10: side_0_track_0_out = side_2_track_0_in;
        2'b11: side_0_track_0_out = side_3_track_0_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[3:2])
        2'b00: side_0_track_1_out = clb_result;
        2'b01: side_0_track_1_out = side_1_track_1_in;
        2'b10: side_0_track_1_out = side_2_track_1_in;
        2'b11: side_0_track_1_out = side_3_track_1_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[5:4])
        2'b00: side_0_track_2_out = clb_result;
        2'b01: side_0_track_2_out = side_1_track_2_in;
        2'b10: side_0_track_2_out = side_2_track_2_in;
        2'b11: side_0_track_2_out = side_3_track_2_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[7:6])
        2'b00: side_0_track_3_out = clb_result;
        2'b01: side_0_track_3_out = side_1_track_3_in;
        2'b10: side_0_track_3_out = side_2_track_3_in;
        2'b11: side_0_track_3_out = side_3_track_3_in;
      endcase
   end

   // Side 1
   always @(*) begin
      case (config_data_reg[9:8])
        2'b00: side_1_track_0_out = side_0_track_0_in;
        2'b01: side_1_track_0_out = clb_result;
        2'b10: side_1_track_0_out = side_2_track_0_in;
        2'b11: side_1_track_0_out = side_3_track_0_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[11:10])
        2'b00: side_1_track_1_out = side_0_track_1_in;
        2'b01: side_1_track_1_out = clb_result;
        2'b10: side_1_track_1_out = side_2_track_1_in;
        2'b11: side_1_track_1_out = side_3_track_1_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[13:12])
        2'b00: side_1_track_2_out = side_0_track_2_in;
        2'b01: side_1_track_2_out = clb_result;
        2'b10: side_1_track_2_out = side_2_track_2_in;
        2'b11: side_1_track_2_out = side_3_track_2_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[15:14])
        2'b00: side_1_track_3_out = side_0_track_3_in;
        2'b01: side_1_track_3_out = clb_result;
        2'b10: side_1_track_3_out = side_2_track_3_in;
        2'b11: side_1_track_3_out = side_3_track_3_in;
      endcase
   end

   // Side 2
   always @(*) begin
      case (config_data_reg[17:16])
        2'b00: side_2_track_0_out = side_0_track_0_in;
        2'b01: side_2_track_0_out = side_1_track_0_in;
        2'b10: side_2_track_0_out = clb_result;
        2'b11: side_2_track_0_out = side_3_track_0_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[19:18])
        2'b00: side_2_track_1_out = side_0_track_1_in;
        2'b01: side_2_track_1_out = side_1_track_1_in;
        2'b10: side_2_track_1_out = clb_result;
        2'b11: side_2_track_1_out = side_3_track_1_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[21:20])
        2'b00: side_2_track_2_out = side_0_track_2_in;
        2'b01: side_2_track_2_out = side_1_track_2_in;
        2'b10: side_2_track_2_out = clb_result;
        2'b11: side_2_track_2_out = side_3_track_2_in;
      endcase
   end

   always @(*) begin
      case (config_data_reg[23:22])
        2'b00: side_2_track_3_out = side_0_track_3_in;
        2'b01: side_2_track_3_out = side_1_track_3_in;
        2'b10: side_2_track_3_out = clb_result;
        2'b11: side_2_track_3_out = side_3_track_3_in;
      endcase
   end

   // Side 3
   always @(*) begin
      case (config_data_reg[25:24])
        2'b00: side_3_track_0_out = side_0_track_0_in;
        2'b01: side_3_track_0_out = side_1_track_0_in;
        2'b10: side_3_track_0_out = side_2_track_0_in;
        2'b11: side_3_track_0_out = clb_result;
      endcase
   end

   always @(*) begin
      case (config_data_reg[27:26])
        2'b00: side_3_track_1_out = side_0_track_1_in;
        2'b01: side_3_track_1_out = side_1_track_1_in;
        2'b10: side_3_track_1_out = side_2_track_1_in;
        2'b11: side_3_track_1_out = clb_result;
      endcase
   end

   always @(*) begin
      case (config_data_reg[29:28])
        2'b00: side_3_track_2_out = side_0_track_2_in;
        2'b01: side_3_track_2_out = side_1_track_2_in;
        2'b10: side_3_track_2_out = side_2_track_2_in;
        2'b11: side_3_track_2_out = clb_result;
      endcase
   end

   always @(*) begin
      case (config_data_reg[31:30])
        2'b00: side_3_track_3_out = side_0_track_3_in;
        2'b01: side_3_track_3_out = side_1_track_3_in;
        2'b10: side_3_track_3_out = side_2_track_3_in;
        2'b11: side_3_track_3_out = clb_result;
      endcase
   end
   
endmodule

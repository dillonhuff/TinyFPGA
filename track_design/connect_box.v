module connect_box(input clk,
                   input rst,

                   input config_en,
                   input [31:0] config_data,

                   input track_0_in,
                   input track_1_in,
                   input track_2_in,
                   input track_3_in,

                   input track_0_out,
                   input track_1_out,
                   input track_2_out,
                   input track_3_out,

                   output out
                   );

   reg [31:0]            config_data_reg;
   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         config_data_reg <= 32'h0;
      end else if (config_en) begin
         config_data_reg <= config_data;
      end
   end

   reg output_wire_reg;
   
   always @(*) begin
      case (config_data_reg)
        32'd0: output_wire_reg = track_0_in;
        32'd1: output_wire_reg = track_1_in;
        32'd2: output_wire_reg = track_2_in;
        32'd3: output_wire_reg = track_3_in;

        32'd4: output_wire_reg = track_0_out;
        32'd5: output_wire_reg = track_1_out;
        32'd6: output_wire_reg = track_2_out;
        32'd7: output_wire_reg = track_3_out;
      endcase
   end // always @ (*)

   always @(posedge clk) begin
      $display("cb config data reg = %b", config_data_reg);
      
   end

   assign out = output_wire_reg;
   
endmodule

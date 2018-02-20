module connect_box(
                   input       track0_in,
                   input       track1_in,
                   input       track2_in,
                   input       track3_in,

                   input  track4_in,
                   input  track5_in,
                   input  track6_in,
                   input  track7_in,
                   
                   output      block_out,

                   input       config_en,
                   input [2:0] config_data,
                   input       clk
                   );

   reg [2:0]             config_data_reg;

   always @(posedge clk)
     begin
        if (config_en)
          begin
             config_data_reg <= config_data;
          end
     end

   /* verilator lint_off UNOPTFLAT */
   reg block_out_i;
   
   always @(*)
     begin
        case (config_data_reg)
          3'd0: block_out_i = track0_in;
          3'd1: block_out_i = track1_in;
          3'd2: block_out_i = track2_in;
          3'd3: block_out_i = track3_in;

          3'd4: block_out_i = track4_in;
          3'd5: block_out_i = track5_in;
          3'd6: block_out_i = track6_in;
          3'd7: block_out_i = track7_in;
        endcase // case endcase
     end

   assign block_out = block_out_i;
   
endmodule // connect_box

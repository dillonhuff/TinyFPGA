module connect_box(
                   input  track0_in,
                   input  track1_in,
                   input  track2_in,
                   input  track3_in,

                   output block_out,

                   input config_en,
                   input [1:0] config_data,
                   input clk
                   );

   reg [1:0]             config_data_reg;

   always @(posedge clk)
     begin
        if (config_en)
          begin
             config_data_reg <= config_data;
          end
     end

   always @(*)
     begin
        case (config_data_reg)
          2'd0: block_out = track0_in;
          2'd1: block_out = track1_in;
          2'd2: block_out = track2_in;
          2'd3: block_out = track3_in;
        endcase // case endcase
     end
   
   
   
endmodule // connect_box

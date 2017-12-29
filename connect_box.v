module connect_box(
                   input  track0_in,
                   input  track1_in,
                   input  track2_in,
                   input  track3_in,

                   output  track0_out,
                   output  track1_out,
                   output  track2_out,
                   output  track3_out,
                   
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

   assign track0_out = track0_in;
   assign track1_out = track1_in;
   assign track2_out = track2_in;
   assign track3_out = track3_in;

   always @(*)
     begin
        case (config_data_reg)
          2'd0: block_out = track0_in;
          2'd1: block_out = track1_in;
          2'd2: block_out = track2_in;
          2'd3: block_out = track3_in;
        endcase // case endcase
     end
   
   
   
endmodule; // connect_box

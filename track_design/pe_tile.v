module pe_tile(input clk,
               input        rst,

               input [31:0] config_addr,
               input [31:0] config_data,

               input [15:0] tile_id,
               
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

               output       side_0_track_0_out,
               output       side_0_track_1_out,
               output       side_0_track_2_out,
               output       side_0_track_3_out,

               output       side_1_track_0_out,
               output       side_1_track_1_out,
               output       side_1_track_2_out,
               output       side_1_track_3_out,

               output       side_2_track_0_out,
               output       side_2_track_1_out,
               output       side_2_track_2_out,
               output       side_2_track_3_out,

               output       side_3_track_0_out,
               output       side_3_track_1_out,
               output       side_3_track_2_out,
               output       side_3_track_3_out
                  );

   
endmodule

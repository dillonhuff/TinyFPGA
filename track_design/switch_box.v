
//                2
//
// 
//  3        switch_box        1
//
//                
//                0

module switch_box(input clk,
                  input  rst,

                  input  config_en,
                  input  [31:0] config_data,

                  // Vertical tracks
                  input  side_0_track_0_in,
                  input  side_0_track_1_in,
                  input  side_0_track_2_in,
                  input  side_0_track_3_in,

                  // Horizontal tracks
                  input  side_1_track_0_in,
                  input  side_1_track_1_in,
                  input  side_1_track_2_in,
                  input  side_1_track_3_in,

                  // Vertical tracks
                  input  side_2_track_0_in,
                  input  side_2_track_1_in,
                  input  side_2_track_2_in,
                  input  side_2_track_3_in,

                  // Horizontal tracks
                  input  side_3_track_0_in,
                  input  side_3_track_1_in,
                  input  side_3_track_2_in,
                  input  side_3_track_3_in,

                  // Vertical tracks
                  output side_0_track_0_out,
                  output side_0_track_1_out,
                  output side_0_track_2_out,
                  output side_0_track_3_out,

                  // Horizontal tracks
                  output side_1_track_0_out,
                  output side_1_track_1_out,
                  output side_1_track_2_out,
                  output side_1_track_3_out,

                  // Vertical tracks
                  output side_2_track_0_out,
                  output side_2_track_1_out,
                  output side_2_track_2_out,
                  output side_2_track_3_out,

                  // Horizontal tracks
                  output side_3_track_0_out,
                  output side_3_track_1_out,
                  output side_3_track_2_out,
                  output side_3_track_3_out
                  );

   // One switch per output track (16 switches), 4 options (2 bits) per switch
   // means 32 bits for the configuration register

   reg [31:0]            config_data_reg;

   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         config_data_reg <= 32'h0;
      end else if (config_en) begin
         config_data_reg <= config_data;
      end
   end
   
endmodule

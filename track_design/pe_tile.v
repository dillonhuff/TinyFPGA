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

   wire                     operand0;
   wire                     operand1;
   wire                     clb_result;
   
   wire                     config_this_tile;
   
   wire                     config_en_cb0;
   wire                     config_en_cb1;
   wire                     config_en_sb;
   wire                     config_en_clb;
   
   

   always @(posedge clk) begin
      $display("running pe");
   end

   assign config_this_tile = config_addr[15:0] == tile_id;
   
   assign config_en_cb0 = config_this_tile && (config_addr[31:16] == 4);
   assign config_en_cb1 = config_this_tile && (config_addr[31:16] == 5);
   assign config_en_sb = config_this_tile && (config_addr[31:16] == 6);
   assign config_en_clb = config_this_tile && (config_addr[31:16] == 7);
   
   
   connect_box cb0(.clk(clk),
                   .rst(rst),
                   .config_en(config_en_cb0),
                   .config_data(config_data),
                   
                   .track_0_in(side_0_track_0_in),
                   .track_1_in(side_0_track_1_in),
                   .track_2_in(side_0_track_2_in),
                   .track_3_in(side_0_track_3_in),

                   .track_0_out(side_0_track_0_out),
                   .track_1_out(side_0_track_1_out),
                   .track_2_out(side_0_track_2_out),
                   .track_3_out(side_0_track_3_out),

                   .out(operand0));

   connect_box cb1(.clk(clk),
                   .rst(rst),
                   .config_en(config_en_cb1),
                   .config_data(config_data),
                   
                   .track_0_in(side_1_track_0_in),
                   .track_1_in(side_1_track_1_in),
                   .track_2_in(side_1_track_2_in),
                   .track_3_in(side_1_track_3_in),

                   .track_0_out(side_1_track_0_out),
                   .track_1_out(side_1_track_1_out),
                   .track_2_out(side_1_track_2_out),
                   .track_3_out(side_1_track_3_out),

                   .out(operand1));

   logic_block clb(.clk(clk), .rst(rst), .config_en(config_en_clb), .config_data(config_data), .operand0(operand0), .operand1(operand1), .result(clb_result));
   

   switch_box sb(.clk(clk),
                 .rst(rst),

                 .config_en(config_en_sb),
                 .config_data(config_data),

                 .side_0_track_0_in(side_0_track_0_in),
                 .side_0_track_1_in(side_0_track_1_in),
                 .side_0_track_2_in(side_0_track_2_in),
                 .side_0_track_3_in(side_0_track_3_in),

                 .side_0_track_0_out(side_0_track_0_out),
                 .side_0_track_1_out(side_0_track_1_out),
                 .side_0_track_2_out(side_0_track_2_out),
                 .side_0_track_3_out(side_0_track_3_out),

                 .side_1_track_0_in(side_1_track_0_in),
                 .side_1_track_1_in(side_1_track_1_in),
                 .side_1_track_2_in(side_1_track_2_in),
                 .side_1_track_3_in(side_1_track_3_in),

                 .side_1_track_0_out(side_1_track_0_out),
                 .side_1_track_1_out(side_1_track_1_out),
                 .side_1_track_2_out(side_1_track_2_out),
                 .side_1_track_3_out(side_1_track_3_out),

                 .side_2_track_0_in(side_2_track_0_in),
                 .side_2_track_1_in(side_2_track_1_in),
                 .side_2_track_2_in(side_2_track_2_in),
                 .side_2_track_3_in(side_2_track_3_in),

                 .side_2_track_0_out(side_2_track_0_out),
                 .side_2_track_1_out(side_2_track_1_out),
                 .side_2_track_2_out(side_2_track_2_out),
                 .side_2_track_3_out(side_2_track_3_out),

                 .side_3_track_0_in(side_3_track_0_in),
                 .side_3_track_1_in(side_3_track_1_in),
                 .side_3_track_2_in(side_3_track_2_in),
                 .side_3_track_3_in(side_3_track_3_in),

                 .side_3_track_0_out(side_3_track_0_out),
                 .side_3_track_1_out(side_3_track_1_out),
                 .side_3_track_2_out(side_3_track_2_out),
                 .side_3_track_3_out(side_3_track_3_out),

                 .clb_result(clb_result)
                 
                 );
   
   
endmodule

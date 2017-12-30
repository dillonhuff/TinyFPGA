`include "clb.v"
`include "connect_box.v"
`include "switch_box.v"

module pe_tile(

               output                         left_0,
               input                          left_1,
               output                         left_2,
               input                          left_3,

               input                          right_0,
               output                         right_1,
               input                          right_2,
               output                         right_3,

               input                          top_0,
               output                         top_1,
               input                          top_2,
               output                         top_3,
   
               output                         bottom_0,
               input                          bottom_1,
               output                         bottom_2,
               input                          bottom_3,
   
               input                          clk,
               input                          config_en,
                  // The address of the block being configured
               input [7:0]                    config_addr,
                  // Config data: 2 bits for CLB, 2 bits for each CB, 16 bits for
                  // the switch block
               input [(2 + 2 + 2 + 16 - 1):0] config_data);


   parameter [7:0] address = 0;

   wire                                       configure_this_tile;

   wire [1:0]                                       cb0_config;
   wire [1:0]                                       cb1_config;
   wire [1:0]                                       clb_config;

   wire [15:0]                                      sb_config;
   
   

   assign configure_this_tile = config_addr == address ? 1 : 0;

   assign cb0_config = config_data[1:0];
   assign cb1_config = config_data[3:2];
   assign clb_config = config_data[5:4];
   assign sb_config = config_data[21:6];
   

   connect_box cb0();
   connect_box cb1();

   wire                                             compute_out;
   
   clb compute_block(cb0.block_out,
                     cb1.block_out,
                     compute_out,
                     configure_this_tile,
                     clb_config);

   
   switch_box sb(
                 left_0,
                 left_1,
                 left_2,
                 left_3,

                 right_0,
                 right_1,
                 right_2,
                 right_3,

                 top_0,
                 top_1,
                 top_2,
                 top_3,

                 bottom_0,
                 bottom_1,
                 bottom_2,
                 bottom_3,

                 compute_out,

                 sb_config,
                 configure_this_tile,
                 clk);
   

   
endmodule

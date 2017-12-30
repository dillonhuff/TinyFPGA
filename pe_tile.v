`include "clb.v"
`include "connect_box.v"
`include "switch_box.v"

module pe_tile(
               
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
   

   assign configure_this_tile = config_addr == address ? 1 : 0;

   assign cb0_config = config_data[1:0];
   assign cb1_config = config_data[3:2];

   // clb compute_block();

   // connect_box cb0();
   // connect_box cb1();

   // switch_box sb
   
endmodule

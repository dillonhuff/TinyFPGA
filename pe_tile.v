module pe_tile(
               
               input                          clk,
               input                          config_en,
               // The address of the block being configured
               input [7:0]                    config_addr,
               // Config data: 2 bits for CLB, 2 bits for each CB, 16 bits for
               // the switch block
               input [(2 + 2 + 2 + 16 - 1):0] config_data);


   parameter [7:0] address = 0;

   
   
endmodule

// The actual logic functions for the FPGA
module function_block(input in0,
                      input in1,
                      output and_out,
                      output or_out,
                      output xor_out);

   assign and_out = in0 & in1;
   assign or_out = in0 | in1;
   assign xor_out = in0 ^ in1;
   
endmodule

// Block that selects which input will be used
module connect_block(input [7:0] in,
                     output      out,
                     input [2:0] config_data,
                     input       config_en,
                     input       clk);

   reg [2:0]                     config_data_reg;

   always @(posedge clk)
     if (config_en)
       config_data_reg <= config_data;

   assign out = in[config_data_reg];
   
   // always @(*) begin
   //    case (config_data_reg)

   //      3'd0: out = in0;
   //      3'd1: out = in1;
   //      3'd2: out = in2;
   //      3'd3: out = in3;
   //      3'd4: out = in4;
   //      3'd5: out = in5;
   //      3'd6: out = in6;
   //      3'd7: out = in7;
        
   //    endcase
   // end

endmodule // connect_block

// Selects which output of the function_block will be output
module output_select(input and_out,
                     input       or_out,
                     input       xor_out,
                     input [1:0] config_data,
                     input       config_en,
                     input       clk,
                     output      reg out);

   reg [1:0] config_data_reg;

   always @(posedge clk)
     if (config_en)
       config_data_reg <= config_data;

   always @(*)
     case (config_data_reg)

       2'd0: out = and_out;
       2'd1: out = or_out;
       2'd2: out = xor_out;
       
     endcase

endmodule // output_select

// The full compute block
module compute_block(input left_in0,
                     input                     left_in1,
                     input                     left_in2,
                     input                     left_in3,
                     input                     left_in4,
                     input                     left_in5,
                     input                     left_in6,
                     input                     left_in7,

                     input                     right_in0,
                     input                     right_in1,
                     input                     right_in2,
                     input                     right_in3,
                     input                     right_in4,
                     input                     right_in5,
                     input                     right_in6,
                     input                     right_in7,

                     input                     clk,
                     input                     config_en,
                     input [5:0]               config_addr,
                     // Need 3 bits for each connect block and 2 bits to select operation
                     input [0:(3 + 3 + 2 - 1)] config_data,
                     output                    out);


   parameter address = 0;

   wire                                        should_config;

   // Only allow configuration when config_en is set and the block being configured
   // is this one
   assign should_config = config_en ? config_addr == address : 0;

   wire                                        left_input;
   wire                                        right_input;
   
   //connect_block left_cb(left_in0, left_in1, left_in2, left_in3, left_in4, left_in5, left_in6, left_in7, left_input, config_data[0:2], should_config, clk);

   //connect_block right_cb(right_in0, right_in1, right_in2, right_in3, right_in4, right_in5, right_in6, right_in7, right_input, config_data[3:5], should_config, clk);

   wire                                        and_out, or_out, xor_out;
   
   function_block func_block(left_input, right_input, and_out, or_out, xor_out);
   
   output_select out_sel(func_block.and_out,
                         func_block.or_out,
                         func_block.xor_out,
                         config_data[6:7],
                         should_config,
                         clk,
                         out);

endmodule // compute_block


module switch_block(
                     input        left_in0,
                     input        left_in1,
                     input        left_in2,
                     input        left_in3,
                     input        left_in4,
                     input        left_in5,
                     input        left_in6,
                     input        left_in7,

                     input        top_in0,
                     input        top_in1,
                     input        top_in2,
                     input        top_in3,
                     input        top_in4,
                     input        top_in5,
                     input        top_in6,
                     input        top_in7,

                     input       func_block_out, 

                     output       right_in0,
                     output       right_in1,
                     output       right_in2,
                     output       right_in3,
                     output       right_in4,
                     output       right_in5,
                     output       right_in6,
                     output       right_in7,

                     output       bottom_in0,
                     output       bottom_in1,
                     output       bottom_in2,
                     output       bottom_in3,
                     output       bottom_in4,
                     output       bottom_in5,
                     output       bottom_in6,
                     output       bottom_in7,

                     input        clk,
                     input        config_en,
                     input [5:0]  config_addr,
                     input [0:79] config_data);
   
endmodule // switch_block


module tile(
                     input        left_in0,
                     input        left_in1,
                     input        left_in2,
                     input        left_in3,
                     input        left_in4,
                     input        left_in5,
                     input        left_in6,
                     input        left_in7,

                     input        top_in0,
                     input        top_in1,
                     input        top_in2,
                     input        top_in3,
                     input        top_in4,
                     input        top_in5,
                     input        top_in6,
                     input        top_in7,

                     output       right_in0,
                     output       right_in1,
                     output       right_in2,
                     output       right_in3,
                     output       right_in4,
                     output       right_in5,
                     output       right_in6,
                     output       right_in7,

                     output       bottom_in0,
                     output       bottom_in1,
                     output       bottom_in2,
                     output       bottom_in3,
                     output       bottom_in4,
                     output       bottom_in5,
                     output       bottom_in6,
                     output       bottom_in7,
                     
                     input        clk,
                     input        config_en,
                     input [5:0]  config_addr,

                     input [0:(80 + 3 + 3 + 2 - 1)] config_data);

   parameter [5:0] address = 0;
   
   wire                                             compute_out;
   
   compute_block cb(bottom_in0,
                    bottom_in1,
                    bottom_in2,
                    bottom_in3,
                    bottom_in4,
                    bottom_in5,
                    bottom_in6,
                    bottom_in7,

                    top_in0,
                    top_in1,
                    top_in2,
                    top_in3,
                    top_in4,
                    top_in5,
                    top_in6,
                    top_in7,

                    clk,
                    config_en,
                    address,
                    config_data [0:(3 + 3 + 2 - 1)],
                    compute_out);


endmodule // tile


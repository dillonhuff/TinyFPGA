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
module compute_block(input [7:0] left_in,
                     input [7:0] right_in,

                     input                     clk,
                     input                     config_en,
                     input [5:0]               config_addr,
                     // Need 3 bits for each connect block and 2 bits to select operation
                     input [0:(3 + 3 + 2 - 1)] config_data,
                     output                    out);


   parameter address = 0;

   wire                                        should_config;

   // TODO: Move this to tile module
   // Only allow configuration when config_en is set and the block being configured
   // is this one
   assign should_config = config_en ? config_addr == address : 0;

   wire                                        left_input;
   wire                                        right_input;

   connect_block left_cb(left_in, left_input, config_data[0:2], should_config, clk);

   connect_block right_cb(right_in, right_input, config_data[3:5], should_config, clk);

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
                    input [7:0]  left_in,
                    output [7:0]  right_in,
                    input [7:0]  top_in,
                    output [7:0] bottom_in,

                    input        func_block_out, 

                    input        clk,
                    input        config_en,
                    input [5:0]  config_addr,
                    input [0:79] config_data);
   

endmodule // switch_block


module tile(
            input [7:0]                    left_in,
            output [7:0]                   right_in,
            input [7:0]                    top_in,
            output [7:0]                   bottom_in,
                     
            input                          clk,
            input                          config_en,
            input [5:0]                    config_addr,

            input [0:(80 + 3 + 3 + 2 - 1)] config_data);

   parameter [5:0] address = 0;
   
   wire                                             compute_out;

   compute_block cb(left_in,
                    top_in,

                    clk,
                    config_en,
                    address,
                    config_data [0:(3 + 3 + 2 - 1)],
                    compute_out);
   

endmodule // tile


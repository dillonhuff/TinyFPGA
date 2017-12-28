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
module connect_block(input in0,
                     input       in1,
                     input       in2,
                     input       in3,
                     input       in4,
                     input       in5,
                     input       in6,
                     input       in7,
                     output      reg out,
                     input [3:0] config_data,
                     input       config_en,
                     input       clk);

   reg [3:0]                     config_data_reg;

   always @(posedge clk)
     if (config_en)
       config_data_reg <= config_data;

   always @(*) begin
      case (config_data_reg)

        3'd0: out = in0;
        3'd1: out = in1;
        3'd2: out = in2;
        3'd3: out = in3;
        3'd4: out = in4;
        3'd5: out = in5;
        3'd6: out = in6;
        3'd7: out = in7;
        
      endcase
   end

endmodule // connect_block

// Selects which output of the function_block will be output
module output_select(input and_out,
                     input       or_out,
                     input       xor_out,
                     input [2:0] config_data,
                     input       config_en,
                     input       clk,
                     output      reg out);

   reg [2:0] config_data_reg;

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

   assign should_config = config_en ? config_addr == address : 0;
   
endmodule

module function_block(input in0,
                      input in1,
                      output and_out,
                      output or_out,
                      output xor_out);

   assign and_out = in0 & in1;
   assign or_out = in0 | in1;
   assign xor_out = in0 ^ in1;
   
endmodule

module connect_block(input in0,
                     input in1,
                     input in2,
                     input in3,
                     input in4,
                     input in5,
                     input in6,
                     input in7,
                     input in8);
endmodule // connect_block

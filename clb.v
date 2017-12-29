module clb(input in0,
           input  in1,
           output and_out,
           output or_out,
           output xor_out);

   assign and_out = in0 & in1;
   assign or_out = in0 | in1;
   assign xor_out = in0 ^ in1;
   
endmodule; // clb

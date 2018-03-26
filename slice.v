module slice
  #(parameter width=1, parameter=start, parameter=end)
(input [$clog2(width) : 0] start_ind,
 input [$clog2(width) : 0] end_ind,
 input [width - 1 : 0] input,
 output [] );

endmodule

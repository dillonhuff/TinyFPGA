module slice_mod #(parameter width=32, parameter start_ind=0, parameter end_ind=31)
   (
    /* verilator lint_off UNUSED */
    input [width - 1:0]              in,
    output [end_ind - start_ind : 0] out);

   assign out = in[end_ind : start_ind];

endmodule

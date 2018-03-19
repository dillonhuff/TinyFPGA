module assign_mod #(parameter width=1) (input [width - 1 : 0] in,
                                        output [width - 1 : 0] out);

   assign out = in;

endmodule

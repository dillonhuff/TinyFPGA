module const_mod #(parameter value=1, parameter width=1)
   (output [width - 1 : 0] out);

   assign out = value;

endmodule

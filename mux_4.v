module mux_4 #(parameter width=1)(input [1:0] sel,
                                  input [width - 1 : 0] in0,
                                  input [width - 1 : 0] in1,
                                  input [width - 1 : 0] in2,
                                  input [width - 1 : 0] in3,
                                  output [width - 1 : 0] out);


   /* verilator lint_off UNOPTFLAT */   
   reg [width - 1 : 0]                                   out_i;

   always @(*) begin
      case (sel)

        2'd0: out_i = in0;
        2'd1: out_i = in1;
        2'd2: out_i = in2;
        2'd3: out_i = in3;
        
      endcase
   end

   assign out = out_i;
   
endmodule

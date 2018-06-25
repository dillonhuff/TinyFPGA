module io1in_pad(input clk,
                 input        rst,

                 input        top_pin,

                 /* verilator lint_off UNUSED */
                 input [15:0] tile_id,

                 output       pin_0,
                 output       pin_1,
                 output       pin_2,
                 output       pin_3);

   assign pin_0 = top_pin;
   assign pin_1 = top_pin;
   assign pin_2 = top_pin;
   assign pin_3 = top_pin;

   always @(posedge clk or negedge rst) begin
      $display("in pin = %b", top_pin);
   end
   
endmodule

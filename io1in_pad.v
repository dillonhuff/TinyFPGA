module io1in_pad(input clk,
                 input top_pin,
                 output pin);

   always @(posedge clk) begin
      pin <= top_pin;
   end

endmodule

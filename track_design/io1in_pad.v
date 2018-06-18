module io1in_pad(input clk,
                 input top_pin,
                 output pin);

   assign pin = top_pin;
   
   always @(posedge clk) begin
      $display("top_pin = %b", top_pin);
      //pin <= top_pin;
   end

endmodule

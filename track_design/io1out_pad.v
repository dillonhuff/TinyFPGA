module io1out_pad(input clk,
                  output top_pin,
                  input  pin);

   assign top_pin = pin;
   
   always @(posedge clk) begin
      $display("out pin = %b", pin);
      
      //top_pin <= pin;
   end

endmodule

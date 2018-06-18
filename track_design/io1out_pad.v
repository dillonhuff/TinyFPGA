module io1out_pad(input clk,
                  output top_pin,
                  input  pin);

   always @(posedge clk) begin
      top_pin <= pin;
   end

endmodule

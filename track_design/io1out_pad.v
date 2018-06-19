module io1out_pad(input clk,
                  input        rst,

                  input        config_en,
                  input [31:0] config_data,
                  
                  output       top_pin,

                  input        pin_0,
                  input        pin_1,
                  input        pin_2,
                  input        pin_3);


   reg [31:0]                  config_data_reg;

   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         config_data_reg <= 0;
      end else if (config_en) begin
         config_data_reg <= config_data;
      end
   end

   reg top_pin_reg;
   always @(*) begin
      case (config_data_reg)
        32'd0: top_pin_reg = pin_0;
        32'd1: top_pin_reg = pin_1;
        32'd2: top_pin_reg = pin_2;
        32'd3: top_pin_reg = pin_3;
      endcase
   end

   assign top_pin = top_pin_reg;
   
   always @(posedge clk) begin
      $display("out pin = %b", top_pin);
      
      //top_pin <= pin;
   end

endmodule

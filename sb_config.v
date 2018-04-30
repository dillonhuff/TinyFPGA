module sb_config #(parameter width=1) (input reset,
                                       input                  clk,
                                       input                  config_en,
                                       input [width - 1 : 0]  config_data_in,
                                       output [width - 1 : 0] config_data_out);

    reg [width - 1:0] config_data_reg;

    always @(posedge clk) begin
       if (reset) begin
          config_data_reg <= 32'b0;
       end else if (config_en) begin
          config_data_reg <= config_data_in;
       end
    end

   assign config_data_out = config_data_reg;

   always @(posedge clk) begin
      $display("sb config_data_out = %b", config_data_out);
      
   end
   
endmodule

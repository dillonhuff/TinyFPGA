module sb_config #(parameter width=1) (input reset,
                                       input                  clk,
                                       input config_en,
                                       output [width - 1 : 0] config_data);

    reg [width - 1:0] config_data_reg;

    always @(posedge clk) begin
       if (reset) begin
          config_data_reg <= 32'b0;
       end else if (config_en) begin
          config_data_reg <= config_data;
       end
    end

   assign config_data = config_data_reg;
   
endmodule

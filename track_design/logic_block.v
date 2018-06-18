module logic_block(input clk,
                   input        rst,

                   input        config_en,
                   input [31:0] config_data,

                   input        operand0,
                   input        operand1,

                   output result);

   reg [31:0]                   config_data_reg;
   
   always @(posedge clk or negedge rst) begin
      if (~rst) begin
         config_data_reg <= 32'h0;
      end else if (config_en) begin
         config_data_reg <= config_data;
      end
   end

   reg result_reg;
   always @(*) begin
      case (config_data_reg)
        32'd0: result_reg = operand0 & operand1;
        32'd1: result_reg = operand0 | operand1;
        32'd2: result_reg = operand0 ^ operand1;
        32'd3: result_reg = ~operand0;
      endcase
   end

   assign result = result_reg;

endmodule

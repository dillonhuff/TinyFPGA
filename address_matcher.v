module address_matcher #(parameter config_id=1, parameter config_flag_value=1, parameter tile_id_end=1, parameter tile_id_begin=1, parameter mod_id_end=1, parameter mod_id_begin=1)
   (input [31:0] config_addr,
    input [15:0] tile_id,
    output       config_reg);

   reg config_reg_i;
   
   always @(*) begin
      if ((config_addr[tile_id_end : tile_id_begin] == tile_id) &&
          (config_addr[mod_id_end : mod_id_begin] == config_flag_value)) begin
         config_reg_i = 1'b1;
      end else begin
         config_reg_i = 1'b0;
      end
   end

   assign config_reg = config_reg_i;

endmodule

module address_matcher #(parameter config_id=1, parameter config_flag_value=1)
   (input [31:0] config_addr,
    input [15:0] tile_id,
    output       config_reg);

         // config_reg = 'config_en_' + mod.inst_name
         // config_flag_value = 'CONFIG_' + mod.inst_name
         // '\treg ' + config_reg + ';\n'
         // '\tlocalparam ' + config_flag_value + ' = ' + str(mod.config_id) + ';\n'

   reg config_reg_i;
   
   always @(*) begin
      if (0) begin //((config_addr[' + str(pe_tile.tile_id_end) + ':' + str(pe_tile.tile_id_begin) + '] == tile_id) && (config_addr[' + str(pe_tile.mod_id_end) + ':' + str(pe_tile.mod_id_begin) + '] == ' + config_flag_value + ')) begin
         config_reg_i = 1'b1;
      end else begin
         config_reg_i = 1'b0;
      end
   end

   assign config_reg = config_reg_i;

endmodule

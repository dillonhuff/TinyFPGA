module address_matcher #(parameter config_id=1, parameter tile_id=1, parameter config_flag_value=1)
   (output config_reg);

         // config_reg = 'config_en_' + mod.inst_name
         // config_flag_value = 'CONFIG_' + mod.inst_name
         // '\treg ' + config_reg + ';\n'
         // '\tlocalparam ' + config_flag_value + ' = ' + str(mod.config_id) + ';\n'
   always @(*) begin
      if (a) begin //((config_addr[' + str(pe_tile.tile_id_end) + ':' + str(pe_tile.tile_id_begin) + '] == tile_id) && (config_addr[' + str(pe_tile.mod_id_end) + ':' + str(pe_tile.mod_id_begin) + '] == ' + config_flag_value + ')) begin\n'
         config_reg = 1'b1;
      end else begin
         config_reg = 1'b0;
      end
            
endmodule

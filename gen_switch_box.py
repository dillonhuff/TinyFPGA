mod_str = 'module switch_box(\n'

mod_str += '\tinput [31:0] config_data,\n'
mod_str += '\tinput [31:0] config_addr,\n'
mod_str += '\tinput clk,\n'
mod_str += '\tinput reset\n'
mod_str += '\t);\n'

mod_str += 'endmodule'

print mod_str

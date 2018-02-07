
n_sides = 4
n_wires_per_side = 4

# Generate the actual string
mod_str = 'module switch_box(\n'

for side_no in range(0, n_sides):
    for wire_no in range(0, n_wires_per_side):
        mod_str += '\tinput ' + 'in_wire_' + str(side_no) + '_' + str(wire_no) + ',\n'

for side_no in range(0, n_sides):
    for wire_no in range(0, n_wires_per_side):
        mod_str += '\toutput ' + 'out_wire_' + str(side_no) + '_' + str(wire_no) + ',\n'
        
mod_str += '\tinput [31:0] config_data,\n'
mod_str += '\tinput config_en,\n'
mod_str += '\tinput clk,\n'
mod_str += '\tinput reset\n'
mod_str += '\t);\n'

mod_str += 'endmodule'

print mod_str

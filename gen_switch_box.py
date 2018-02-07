
def build_mod_str(n_sides, n_wires_per_side):
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
    mod_str += '\t);\n\n'

    mod_str += '\treg [31:0] config_data_reg;\n'
    mod_str += '\talways @(posedge clk) begin\n'
    mod_str += '\t\tif (reset) begin\n'
    mod_str += '\t\t\tconfig_data_reg <= 32\'b0;\n'
    mod_str += '\t\tend else if (config_en) begin\n'
    mod_str += '\t\t\tconfig_data_reg <= config_data\n'
    mod_str += '\t\tend\n'
    mod_str += '\tend\n\n'

    mod_str += 'endmodule'
    return mod_str

print build_mod_str(4, 4)

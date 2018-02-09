from sets import Set


def build_mod_str(mod_name, sides_to_use, n_sides, n_wires_per_side):

    assert(len(sides_to_use) <= n_sides)

    input_wires = Set([])
    out_map_nums = []
    config_offset = 0

    # Generate all valid connections
    for side_no in range(0, n_sides):

        for wire_no in range(0, n_wires_per_side):
            sources = []

            for i in range(0, n_wires_per_side - 1):

                wire_side = (side_no + i + 1) % n_sides

                in_wire = (wire_side, (side_no + wire_no + i) % n_wires_per_side)

                sources.append((i, in_wire))

            out_map_nums.append(((side_no, wire_no), sources, config_offset))

            config_offset += 2

    output_map = []
    for val in out_map_nums:

        side_no = val[0][0]
        out_wire_no = val[0][1]

        if side_no in sides_to_use:
            config_offset = val[2]
            sources = []
            # check each value in source
            for src in val[1]:
                in_side_no = src[0]
                i = src[1][0]
                in_wire_no = src[1][1]
                if in_side_no in sides_to_use:
                    in_wire_name = 'in_wire_' + str(in_side_no) + '_' + str(in_wire_no)
                    sources.append(in_wire_name)

                    input_wires.add(in_wire_name)

            output_map.append(('out_wire_' + str(side_no) + '_' + str(out_wire_no), sources, config_offset))

    # Generate the actual string
    mod_str = 'module ' + mod_name + '(\n'

    for in_wire in input_wires:
        mod_str += '\tinput ' + in_wire + ',\n'

    for output in output_map:
        mod_str += '\toutput ' + output[0] + ',\n'
            
    mod_str += '\tinput pe_output_0,\n'
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
    mod_str += '\t\t\tconfig_data_reg <= config_data;\n'
    mod_str += '\t\tend\n'
    mod_str += '\tend\n\n\n'

    for output in output_map:
        mod_str += '\treg ' + output[0] + '_i;\n'

    mod_str += '\n'

    data_reg_start = 0
    for output in output_map:
        out_wire = output[0]
        data_reg_start = output[2]
        
        mod_str += '\talways @(*) begin\n'

        mod_str += '\t\tcase (config_data_reg[' + str(data_reg_start + 1) + ':' + str(data_reg_start) + '])\n'

        data_reg_start += 2

        for ind_wire_pair in output[1]:
            i = ind_wire_pair[0]
            in_wire = ind_wire_pair[1]
                
            mod_str += '\t\t\t2\'d' + str(i) + ': ' + out_wire + '_i = ' + in_wire + ';\n'

        mod_str += '\t\t\t2\'d3: ' + out_wire + '_i = pe_output_0;\n'

        mod_str += '\t\t\tdefault: ' + out_wire + '_i = 1\'b0;\n'
        mod_str += '\t\tendcase\n'

        mod_str += '\tend\n\n'

        mod_str += '\tassign ' + out_wire + ' = ' + out_wire + '_i;\n\n';
        
        
    mod_str += '\n\n'

    mod_str += 'endmodule'

    return mod_str

# Center switch box
sb_file = open('switch_box.v', 'w')
sb_file.write(build_mod_str('switch_box', [0, 1, 2, 3], 4, 4))
sb_file.close()

# Middle side switch box
sb_file = open('switch_box_top.v', 'w')
sb_file.write(build_mod_str('switch_box', [0, 1, 2], 4, 4))
sb_file.close()

sb_file = open('switch_box_left.v', 'w')
sb_file.write(build_mod_str('switch_box', [0, 1, 3], 4, 4))
sb_file.close()

sb_file = open('switch_box_right.v', 'w')
sb_file.write(build_mod_str('switch_box', [1, 2, 3], 4, 4))
sb_file.close()

sb_file = open('switch_box_bottom.v', 'w')
sb_file.write(build_mod_str('switch_box', [0, 2, 3], 4, 4))
sb_file.close()

# Corner switch boxes
sb_file = open('switch_box_top_left.v', 'w')
sb_file.write(build_mod_str('switch_box_top_left', [0, 1], 4, 4))
sb_file.close()

sb_file = open('switch_box_top_right.v', 'w')
sb_file.write(build_mod_str('switch_box_top_right', [1, 2], 4, 4))
sb_file.close()

sb_file = open('switch_box_bottom_left.v', 'w')
sb_file.write(build_mod_str('switch_box_bottom_left', [0, 3], 4, 4))
sb_file.close()

sb_file = open('switch_box_bottom_right.v', 'w')
sb_file.write(build_mod_str('switch_box_bottom_right', [2, 3], 4, 4))
sb_file.close()

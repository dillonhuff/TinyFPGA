
def build_mod_str(n_sides, n_wires_per_side):
    # Generate the actual string
    mod_str = 'module switch_box(\n'

    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            mod_str += '\tinput ' + 'in_wire_' + str(side_no) + '_' + str(wire_no) + ',\n'

    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            mod_str += '\toutput ' + 'out_wire_' + str(side_no) + '_' + str(wire_no) + ',\n'

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

    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            mod_str += '\treg out_wire_' + str(side_no) + '_' + str(wire_no) + '_i;\n';

    mod_str += '\n'

    output_map = []
    for side_no in range(0, n_sides):

        for wire_no in range(0, n_wires_per_side):
            sources = []

            for i in range(0, n_wires_per_side - 1):
                sources.append((i, 'in_wire_' + str((side_no + i + 1) % n_sides) + '_' + str((side_no + wire_no + i) % n_wires_per_side)))

            output_map.append(('out_wire_' + str(side_no) + '_' + str(wire_no) + '_i', sources))

    data_reg_start = 0

    for output in output_map:
        out_wire = output[0]
        
        mod_str += '\talways @(*) begin\n'

        mod_str += '\t\tcase (config_data_reg[' + str(data_reg_start + 1) + ':' + str(data_reg_start) + '])\n'

        data_reg_start += 2

        for ind_wire_pair in output[1]:
            i = ind_wire_pair[0]
            in_wire = ind_wire_pair[1]
                
            mod_str += '\t\t\t2\'d' + str(i) + ': ' + out_wire + ' = ' + in_wire + ';\n'

        mod_str += '\t\t\t2\'d3: ' + out_wire + ' = pe_output_0;\n'

        mod_str += '\t\t\tdefault: ' + out_wire + ' = 1\'b0;\n'
        mod_str += '\t\tendcase\n'

        mod_str += '\tend\n\n'

        mod_str += '\tassign ' + out_wire[0:len(out_wire) - 2] + ' = ' + out_wire + ';\n\n';
        
        
    mod_str += '\n'

    # for side_no in range(0, n_sides):
    #     for wire_no in range(0, n_wires_per_side):
    #         mod_str += '\tassign out_wire_' + str(side_no) + '_' + str(wire_no) + ' = out_wire_' + str(side_no) + '_' + str(wire_no) + '_i;\n';

    mod_str += '\n'
    
    mod_str += 'endmodule'
    return mod_str

sb_file = open('switch_box.v', 'w')
sb_file.write(build_mod_str(4, 4))
sb_file.close()

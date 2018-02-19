from sets import Set

import json

# Note: Maybe the programmable elements should have a base set like CLB / switch
# that are instantiated, combinational modules that take config inputs

def build_box_topology(sides_to_use, n_sides, n_wires_per_side):
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

    # Select the valid connections
    output_map = []
    for val in out_map_nums:

        side_no = val[0][0]
        out_wire_no = val[0][1]

        if side_no in sides_to_use:
            config_offset = val[2]
            sources = []
            # check each value in source
            for src in val[1]:
                in_side_no = src[1][0]
                i = src[0]
                in_wire_no = src[1][1]

                in_wire_name = 'in_wire_' + str(in_side_no) + '_' + str(in_wire_no)

                sources.append((i, in_wire_name))

                input_wires.add(in_wire_name)

            sources.append((n_wires_per_side - 1, 'pe_output_0'))
            output_map.append(('out_wire_' + str(side_no) + '_' + str(out_wire_no), sources, config_offset))

    return (output_map, input_wires)

# What should the layout of modules in json be?
# List of components:
# Component contains: 
def generate_sb_json(mod_name, output_map, input_wires):
    json_val = {}
    json_val['mod_name'] = mod_name

    json_val['inputs'] = list(input_wires)

    output_wires = []
    switches = []

    for output in output_map:

        config_map = {}
        
        output_wires.append(output[0])

        switch_inputs = []
        for in_wire in output[1]:
            switch_inputs.append(in_wire[1])
            config_map[in_wire[1]] = in_wire[0]
        
        switches.append({'name' : output[0], 'offset' : output[2], 'config_map' : config_map})

    json_val['outputs'] = output_wires
    json_val['components'] = switches

    
    json_str = json.dumps(json_val)

    return json_str

def generate_sb_verilog(mod_name, output_map, input_wires):
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

    mod_str += '\t/* verilator lint_off UNUSED */\n'
    mod_str += '\treg [31:0] config_data_reg;\n'
    mod_str += '\talways @(posedge clk) begin\n'
    mod_str += '\t\tif (reset) begin\n'
    mod_str += '\t\t\tconfig_data_reg <= 32\'b0;\n'
    mod_str += '\t\tend else if (config_en) begin\n'
    mod_str += '\t\t\tconfig_data_reg <= config_data;\n'
    mod_str += '\t\tend\n'
    mod_str += '\tend\n\n\n'

    for output in output_map:
        mod_str += '\t/* verilator lint_off UNOPTFLAT */\n'
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

        mod_str += '\t\t\tdefault: ' + out_wire + '_i = 1\'b0;\n'
        mod_str += '\t\tendcase\n'

        mod_str += '\tend\n\n'

        mod_str += '\tassign ' + out_wire + ' = ' + out_wire + '_i;\n\n';
        
        
    mod_str += '\n\n'

    mod_str += 'endmodule'

    return mod_str
    
def build_mod_str(mod_name, sides_to_use, n_sides, n_wires_per_side):

    (output_map, input_wires) = build_box_topology(sides_to_use, n_sides, n_wires_per_side)

    verilog = generate_sb_verilog(mod_name, output_map, input_wires)
    json = generate_sb_json(mod_name, output_map, input_wires)
    return (verilog, json)

def generate_sb(mod_name, sides_to_use, n_sides, n_wires_per_side):

    (verilog_str, json_str) = build_mod_str(mod_name, sides_to_use, n_sides, n_wires_per_side)
    sb_file = open(mod_name + '.v', 'w')
    sb_file.write(verilog_str)
    sb_file.close()

    sb_file = open(mod_name + '.json', 'w')
    sb_file.write(json_str)
    sb_file.close()
    

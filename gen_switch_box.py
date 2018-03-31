from sets import Set
from verilog import VerilogModule, VerilogModuleInstance
from generator_utils import module_string

import json

# Note: Maybe the programmable elements should have a base set like CLB / switch
# that are instantiated, combinational modules that take config inputs

# Maybe next steps are:
# 1. Change switch box to use verilog module
# 2. Build PE tile data structure that the PE tile verilog and json both consume
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
    ports = []
    for in_wire in input_wires:
        ports.append('input ' + in_wire)

    for output in output_map:
        ports.append('output ' + output[0])

    ports.append('input pe_output_0')
    ports.append('input [31:0] config_data')
    ports.append('input config_en')
    ports.append('input clk')
    ports.append('input reset')

    sb_mod = VerilogModule(mod_name, ports)

    sb_mod.add_wire('config_data_reg', 32)
    sb_mod.add_instance('sb_config', 'configuration', {'width' : 32})
    sb_mod.add_wire_connection('config_data_reg', 'configuration', 'config_data')
    sb_mod.add_port_connection('clk', 'configuration', 'clk')
    sb_mod.add_port_connection('reset', 'configuration', 'reset')
    sb_mod.add_port_connection('config_en', 'configuration', 'config_en')

    #     for output in output_map:
    #         mod_str += '\t/* verilator lint_off UNOPTFLAT */\n'
    #         mod_str += '\treg ' + output[0] + '_i;\n'
    
    #     mod_str += '\n'

    data_reg_start = 0
    for output in output_map:
        # Add wires to module and create programmable switch module to control this
        # box
        #output_reg = output[0] + '_i'
        #sb_mod.add_reg(output[0] + '_i', 1)
        out_wire = output[0]
        data_reg_start = output[2]

        #config_slice_wire = sb_mod.fresh_wire(2)

        config_slice_wire = 'slice_' + out_wire
        slice_name = config_slice_wire + '_slice'
        sb_mod.add_instance('slice_mod', slice_name, {'start_ind' : data_reg_start, 'end_ind' : data_reg_start + 1, 'width' : 32})
        sb_mod.add_port_connection('config_data_reg', slice_name, 'in')

        slice_out = sb_mod.add_wire(config_slice_wire + '_sel_out', 2)
        sb_mod.add_port_connection(slice_out, slice_name, 'out')

        switch_name = config_slice_wire + '_mux_4'
        sb_mod.add_instance('mux_4', switch_name, {'width' : 1})
        sb_mod.add_port_connection(out_wire, switch_name, 'out')
        sb_mod.add_port_connection(slice_out, switch_name, 'sel')
        for ind_wire_pair in output[1]:
            i = ind_wire_pair[0]
            in_wire = ind_wire_pair[1]
            sb_mod.add_port_connection(in_wire, switch_name, 'in' + str(i))
            #mod_str += '\t\t\t2\'d' + str(i) + ': ' + out_wire + '_i = ' + in_wire +            
        
        #data_reg_start += 2
        #mod_str += '\talways @(*) begin\n'

        #mod_str += '\t\tcase (config_data_reg[' + str(data_reg_start + 1) + ':' + str(data_reg_start) + '])\n'

        # for ind_wire_pair in output[1]:
        #     i = ind_wire_pair[0]
        #     in_wire = ind_wire_pair[1]
        #     mod_str += '\t\t\t2\'d' + str(i) + ': ' + out_wire + '_i = ' + in_wire + ';\n'

        # mod_str += '\t\t\tdefault: ' + out_wire + '_i = 1\'b0;\n'
        # mod_str += '\t\tendcase\n'

        # mod_str += '\tend\n\n'

        # mod_str += '\tassign ' + out_wire + ' = ' + out_wire + '_i;\n\n';

    return module_string([], sb_mod.mod_name, sb_mod.ports, sb_mod.body_string())

def build_sb_bitstream_json(mod_name, output_map):
    json_val = {}
    json_val['mod_name'] = mod_name

    output_wires = []
    switches = []

    for output in output_map:

        config_map = {}
        
        switch_inputs = []
        for in_wire in output[1]:
            switch_inputs.append(in_wire[1])
            config_map[in_wire[1]] = in_wire[0]
        
        switches.append({'name' : output[0], 'offset' : output[2], 'config_map' : config_map})

    json_val['components'] = switches

    
    return json_val

def build_mod_str(mod_name, sides_to_use, n_sides, n_wires_per_side):

    (output_map, input_wires) = build_box_topology(sides_to_use, n_sides, n_wires_per_side)

    verilog = generate_sb_verilog(mod_name, output_map, input_wires)
    json = generate_sb_json(mod_name, output_map, input_wires)
    return (verilog, json, build_sb_bitstream_json(mod_name, output_map))

def generate_sb(mod_name, sides_to_use, n_sides, n_wires_per_side):

    (verilog_str, json_str, bs_json) = build_mod_str(mod_name, sides_to_use, n_sides, n_wires_per_side)
    sb_file = open(mod_name + '.v', 'w')
    sb_file.write(verilog_str)
    sb_file.close()

    sb_file = open(mod_name + '.json', 'w')
    sb_file.write(json_str)
    sb_file.close()

    return bs_json
    

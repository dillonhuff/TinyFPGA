from sets import Set

# How do I want to represent the topology of the entire chip?

# The goal is to have a single place and route algorithm that can
# handle any parametrized fabric

# There is a set of inputs, a bunch of connection points, and a bunch
# of switches. Also there is a bitstream format that is used to capture
# how to map a named topology to a bitstream

# Note: Connections are directional

# Need to generate topology for the top module, switch boxes, and connect boxes

# For bitstream conversion I need to develop a way to convert the PnR format to
# bits

# In a perfect world: I would generate a chip layout data structure, then generate
# the verilog to go with the layout from the layout DS and generate the PnR format
# from the layout DS as well

# Layout format: Nodes and ports
# Node types: PEs, In pads, Out pads, Switches
# Ports on nodes: Inputs, Outputs

# In this scheme:

# CLB is just a black box with 2 inputs, 1 output and a label

# Switch is a black box with N inputs, 1 output and a label?

# Input pad is a black box with 1 output

# Output pad is a black box with 1 input

# Connect box is a box with 8 inputs, 1 output. Internally it is a switch
# Switch box has a bunch of inputs / outputs, internally its a bunch of switches

# Placement is about assigning one tile_id to each CLB, input, and output in
# the application graph. Then assigning paths to each edge such that:
# 1. The sequence of connections maps ports to ports

# Is it about assigning paths to each edge? Or about assigning labels to
# switches?

# Note: Maybe the next thing to do is convert the configuration logic to be
# auto generated and then write my own bitstream converter for it (in C++)?

# What is the structure of the bitstream converter? Functions for generating
# configuration data from pairs of connections and from labels?

# Switches labeled by which input they will carry through, CLBs labeled by
# which operation they will use

# Configuration data is a mapping from labels to bits

# Configuration address is a mapping from addresses to configurable elements.
# This has a hierarchy. Tiles have addresses and the components inside tiles have
# config enable bits set by tile addresses. So the address is a hierarchy
# [ Tile address bits | subcomponent address bits ]

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
                in_side_no = src[1][0] #src[0]
                i = src[0] #src[1][0]
                in_wire_no = src[1][1]

                in_wire_name = 'in_wire_' + str(in_side_no) + '_' + str(in_wire_no)

                sources.append((i, in_wire_name))

                input_wires.add(in_wire_name)

            output_map.append(('out_wire_' + str(side_no) + '_' + str(out_wire_no), sources, config_offset))

    return (output_map, input_wires)

def generate_sb_json(mod_name, output_map, input_wires):
    json_str = '{\n'
    json_str += 'mod_name : ' + mod_name + ',\n'

    json_str += 'inputs\n'
    for in_wire in input_wires:
        json_str += '\t' + in_wire + '\n'

    json_str += 'outputs\n'
    for output in output_map:
        json_str += '\t' + output[0] + '\n'

    json_str += 'connections : \n'
    for output in output_map:
        json_str += '\t' + output[0] + '\n'

        for out in output[1]:
            json_str += '\t\t' + out[1] + '\n'

    json_str += '\n}\n'
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

        mod_str += '\t\t\t2\'d3: ' + out_wire + '_i = pe_output_0;\n'

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
    

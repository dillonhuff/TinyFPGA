def module_string(includes, name, ports, body):
    mod_str = ""
    for include_name in includes:
        mod_str += '`include \"' + include_name + '\"\n'

    mod_str += '\n\n'

    mod_str += 'module ' + name + '(\n'

    for i in range(0, len(ports)):
        mod_str += '\t' + ports[i]
        if (i != (len(ports) - 1)):
            mod_str += ',\n'

    mod_str += '\n\t);\n\n'

    mod_str += body

    mod_str += '\n\n'
    mod_str += 'endmodule'

    return mod_str

def build_pe_tile_str(n_sides, n_wires_per_side):
    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data', 'input [15:0] tile_id']

    for side in range(0, n_sides):
        for wire in range(0, n_wires_per_side):
            ports.append('input in_wire_' + str(side) + '_' + str(wire))

    for side in range(0, n_sides):
        for wire in range(0, n_wires_per_side):
            ports.append('output out_wire_' + str(side) + '_' + str(wire))

    body = '\n'

    body += '\tlocalparam CONFIG_SB = 7;\n\n'
    body += '\twire op_0;\n'
    body += '\twire op_1;\n'
    body += '\twire pe_output;\n\n'

    body += '\t// Switch box config\n'
    body += '\treg config_en_sb;\n\n'
    body += '\talways @(*) begin\n'
    body += '\t\tif ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_SB)) begin\n'
    body += '\t\t\tconfig_en_sb = 1\'b1;\n'
    body += '\t\tend\n'
    body += '\tend\n\n'

    body += '\tconnect_box cb0(\n'

    for wire in range(0, n_wires_per_side):
        body += '\t\t.track' + str(wire) + '_in(in_wire_0_' + str(wire) + '),\n'

    body += '\t\t.block_out(op_0),\n'
    # Replace this dummy
    body += '\t\t.config_en(1\'b0),\n'
    # Replace this dummy
    body += '\t\t.config_data(2\'b0),\n'
    body += '\t\t.clk(clk)\n'
    body += '\t);\n\n'

    body += '\tconnect_box cb1(\n'

    for wire in range(0, n_wires_per_side):
        body += '\t\t.track' + str(wire) + '_in(in_wire_1_' + str(wire) + '),\n'

    body += '\t\t.block_out(op_1),\n'
    # Replace this dummy
    body += '\t\t.config_en(1\'b0),\n'
    # Replace this dummy
    body += '\t\t.config_data(2\'b0),\n'
    body += '\t\t.clk(clk)\n'
    body += '\t);\n\n'

    body += '\tswitch_box sb(\n'
    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            port_name = 'in_wire_' + str(side_no) + '_' + str(wire_no)
            body += '\t\t.' + port_name + '(' + port_name + '),\n';

    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            port_name = 'out_wire_' + str(side_no) + '_' + str(wire_no)
            body += '\t\t.' + port_name + '(' + port_name + '),\n';

    body += '\t\t.pe_output_0(pe_output),\n'
    body += '\t\t.config_data(config_data),\n'
    body += '\t\t.config_en(1\'b0),\n'
    body += '\t\t.clk(clk),\n'
    body += '\t\t.reset(reset)\n'
    body += '\t\t);\n\n'

    body += '\tclb compute_block(\n'
    body += '\t\t.in0(op_0),\n'
    body += '\t\t.in1(op_1),\n'
    body += '\t\t.clk(clk),\n'
    body += '\t\t.config_enable(config_en_sb),\n'
    body += '\t\t.config_data(2\'b0),\n'
    body += '\t\t.out(pe_output)\n'
    body += '\t\t);\n\n'

    return module_string(['clb.v', 'connect_box.v', 'switch_box.v'],
                         'pe_tile',
                         ports,
                         body)

pe_tile_file = open('pe_tile.v', 'w')
pe_tile_file.write(build_pe_tile_str(4, 4))
pe_tile_file.close()


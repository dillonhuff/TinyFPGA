from generator_utils import module_string

# Note: perhaps the connect box should be attached to outputs? or to both inputs and
# outputs?
def build_pe_tile_str(mod_name,
                      switch_box_mod,
                      sides_to_use,
                      n_sides,
                      n_wires_per_side):
    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data', 'input [15:0] tile_id']

    for side in range(0, n_sides):
        for wire in range(0, n_wires_per_side):
            ports.append('input in_wire_' + str(side) + '_' + str(wire))

    for side in range(0, n_sides):
        if side in sides_to_use:
            for wire in range(0, n_wires_per_side):
                ports.append('output out_wire_' + str(side) + '_' + str(wire))

    body = '\n'

    body += '\tlocalparam CONFIG_SB = 7;\n'
    body += '\tlocalparam CONFIG_CB0 = 6;\n'
    body += '\tlocalparam CONFIG_CB1 = 5;\n'
    body += '\tlocalparam CONFIG_CLB = 4;\n\n'
    body += '\twire op_0;\n'
    body += '\twire op_1;\n'
    body += '\twire pe_output;\n\n'

    body += '\t// Switch box config\n'
    body += '\treg config_en_sb;\n\n'
    body += '\treg config_en_cb0;\n\n'
    body += '\treg config_en_cb1;\n\n'
    body += '\treg config_en_clb;\n\n'

    body += '\talways @(*) begin\n'
    body += '\t\tif ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_SB)) begin\n'
    body += '\t\t\tconfig_en_sb = 1\'b1;\n'
    body += '\t\tend else begin\n'
    body += '\t\t\tconfig_en_sb = 1\'b0;\n'
    body += '\t\tend\n'
    body += '\tend\n\n'

    body += '\talways @(*) begin\n'
    body += '\t\tif ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_CB0)) begin\n'
    body += '\t\t\tconfig_en_cb0 = 1\'b1;\n'
    body += '\t\tend else begin\n'
    body += '\t\t\tconfig_en_cb0 = 1\'b0;\n'
    body += '\t\tend\n'
    body += '\tend\n\n'

    body += '\talways @(*) begin\n'
    body += '\t\tif ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_CB1)) begin\n'
    body += '\t\t\tconfig_en_cb1 = 1\'b1;\n'
    body += '\t\tend else begin\n'
    body += '\t\t\tconfig_en_cb1 = 1\'b0;\n'
    body += '\t\tend\n'
    body += '\tend\n\n'

    body += '\talways @(*) begin\n'
    body += '\t\tif ((config_addr[15:0] == tile_id) && (config_addr[31:16] == CONFIG_CLB)) begin\n'
    body += '\t\t\tconfig_en_clb = 1\'b1;\n'
    body += '\t\tend else begin\n'
    body += '\t\t\tconfig_en_clb = 1\'b0;\n'
    body += '\t\tend\n'
    body += '\tend\n\n'

    body += '\tconnect_box cb0(\n'

    for wire in range(0, n_wires_per_side):
        body += '\t\t.track' + str(wire) + '_in(in_wire_0_' + str(wire) + '),\n'

    body += '\t\t.block_out(op_0),\n'
    # Replace this dummy
    body += '\t\t.config_en(config_en_cb0),\n'
    # Replace this dummy
    body += '\t\t.config_data(config_data[1:0]),\n'
    body += '\t\t.clk(clk)\n'
    body += '\t);\n\n'

    body += '\tconnect_box cb1(\n'

    for wire in range(0, n_wires_per_side):
        body += '\t\t.track' + str(wire) + '_in(in_wire_1_' + str(wire) + '),\n'

    body += '\t\t.block_out(op_1),\n'
    # Replace this dummy
    body += '\t\t.config_en(config_en_cb1),\n'
    # Replace this dummy
    body += '\t\t.config_data(config_data[1:0]),\n'
    body += '\t\t.clk(clk)\n'
    body += '\t);\n\n'

    body += '\t' + switch_box_mod + ' sb(\n'
    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            port_name = 'in_wire_' + str(side_no) + '_' + str(wire_no)
            body += '\t\t.' + port_name + '(' + port_name + '),\n';

    for side_no in range(0, n_sides):
        if side_no in sides_to_use:
            for wire_no in range(0, n_wires_per_side):
                port_name = 'out_wire_' + str(side_no) + '_' + str(wire_no)
                body += '\t\t.' + port_name + '(' + port_name + '),\n';

    body += '\t\t.pe_output_0(pe_output),\n'
    body += '\t\t.config_data(config_data),\n'
    body += '\t\t.config_en(config_en_sb),\n'
    body += '\t\t.clk(clk),\n'
    body += '\t\t.reset(reset)\n'
    body += '\t\t);\n\n'

    body += '\tclb compute_block(\n'
    body += '\t\t.in0(op_0),\n'
    body += '\t\t.in1(op_1),\n'
    body += '\t\t.clk(clk),\n'
    body += '\t\t.config_enable(config_en_clb),\n'
    body += '\t\t.config_data(config_data[1:0]),\n'
    body += '\t\t.out(pe_output)\n'
    body += '\t\t);\n\n'

    return module_string(['clb.v', 'connect_box.v', 'switch_box.v'],
                         mod_name,
                         ports,
                         body)

pe_tile_file = open('pe_tile.v', 'w')
pe_tile_file.write(build_pe_tile_str('pe_tile', 'switch_box', [0, 1, 2, 3], 4, 4))
pe_tile_file.close()

# Note: Need custom switch boxes for top and bottom, since those need to receive
# one input
# Side PEs
pe_tile_file = open('pe_tile_left.v', 'w')
pe_tile_file.write(build_pe_tile_str('pe_tile_left', 'switch_box_left', [0, 1, 3], 4, 4))
pe_tile_file.close()

pe_tile_file = open('pe_tile_right.v', 'w')
pe_tile_file.write(build_pe_tile_str('pe_tile_right', 'switch_box_right', [1, 2, 3], 4, 4))
pe_tile_file.close()

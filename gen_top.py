from generator_utils import module_string

def build_top_str(num_in_ios,
                  num_out_ios,
                  grid_height,
                  grid_width):

    assert(num_in_ios <= grid_width);
    assert(num_out_ios <= grid_width);

    includes = ['pe_tile', 'io1in_pad', 'io1out_pad']
    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data']

    for pad_no in range(0, num_in_ios):
        ports.append('input in_wire_' + str(pad_no))

    for pad_no in range(0, num_out_ios):
        ports.append('output out_wire_' + str(pad_no))

    # Need to initialize wire groups:
    # 1. input io pads to tile grid
    # 2. output io pads to top
    # 3. wires between each pad on the grid
    body = ''

    # Initialize io pads to tile
    for pad_no in range(0, num_in_ios):
        body += '\twire input_to_grid_' + str(pad_no) + ';\n'

    body += '\n\n'

    for pad_no in range(0, num_out_ios):
        body += '\twire grid_to_output_' + str(pad_no) + ';\n'

    body += '\n\n'
        
    for pad_no in range(0, num_in_ios):
        body += '\tio1in_pad in_pad_' + str(pad_no) + '(\n'
        body += '\t\t.clk(clk),\n'
        body += '\t\t.top_pin(in_wire_' + str(pad_no) + '),\n'
        body += '\t\t.pin(input_to_grid_' + str(pad_no) + ')\n'
        body += '\t);\n\n'

    for pad_no in range(0, num_out_ios):
        body += '\tio1out_pad out_pad_' + str(pad_no) + '(\n'
        body += '\t\t.clk(clk),\n'
        body += '\t\t.top_pin(out_wire_' + str(pad_no) + '),\n'
        body += '\t\t.pin(grid_to_output_' + str(pad_no) + ')\n'
        body += '\t);\n\n'
        
    return module_string(includes, 'top', ports, body)

pe_tile_file = open('top.v', 'w')
pe_tile_file.write(build_top_str(16, 16, 16, 16))
pe_tile_file.close()
    

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

    body += '\t// PE tile grid\n'
    tile_id = 1;

    for grid_row in range(0, grid_height):

        prev_row = grid_row - 1
        next_row = grid_row + 1

        for grid_col in range(0, grid_width):

            prev_col = grid_col - 1
            next_col = grid_col + 1

            body += '\tpe_tile pe_tile_' + str(grid_row) + '_' + str(grid_col) + '(\n'


            if ((grid_row == 0) and (grid_col <= (num_in_ios - 1))):
                body += '\t\t.in_wire_3_0(input_to_grid_' + str(grid_col) + '),\n'

            if ((grid_row == (grid_height - 1)) and (grid_col <= (num_out_ios - 1))):
                body += '\t\t.out_wire_1_0(grid_to_output_' + str(grid_col) + '),\n'
            elif (grid_row != (grid_height - 1)):
                for wire_no in range(0, 4):
                    body += '\t\t.out_wire_1_' + str(wire_no) + '(pe_tile_' + str(next_row) + '_' + str(grid_col) + '.in_wire_3_' + str(wire_no) + '),\n'

            body += '\t\t.clk(clk),\n'
            body += '\t\t.reset(reset),\n'
            body += '\t\t.config_addr(config_addr),\n'
            body += '\t\t.config_data(config_data),\n'
            body += '\t\t.tile_id(' + str(tile_id) + ')\n'

            body += '\t);\n\n'
            tile_id += 1

    return module_string(includes, 'top', ports, body)

pe_tile_file = open('top.v', 'w')
pe_tile_file.write(build_top_str(2, 2, 2, 2))
pe_tile_file.close()
    

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

    body += '\t// \n'

    
    body += '\t// input pads\n'
    for pad_no in range(0, num_in_ios):
        body += '\tio1in_pad in_pad_' + str(pad_no) + '(\n'
        body += '\t\t.clk(clk),\n'
        body += '\t\t.top_pin(in_wire_' + str(pad_no) + '),\n'
        body += '\t\t.pin(input_to_grid_' + str(pad_no) + ')\n'
        body += '\t);\n\n'

    body += '\t// output pads\n'
    for pad_no in range(0, num_out_ios):
        body += '\tio1out_pad out_pad_' + str(pad_no) + '(\n'
        body += '\t\t.clk(clk),\n'
        body += '\t\t.top_pin(out_wire_' + str(pad_no) + '),\n'
        body += '\t\t.pin(grid_to_output_' + str(pad_no) + ')\n'
        body += '\t);\n\n'

    body += '\t// PE tile grid\n'
    tile_id = 1;


    #           3
    #
    #    2             0
    #          
    #           1
    #

    top_side = 3
    left_side = 2
    bottom_side = 1
    right_side = 0

    # Q: How to name the wires that connect different tiles?
    # Each tile-direction group needs 4 wires, and there are 2 groups
    # tile00 -> tile01, tile00 <- tile01

    body += '\t// Vertical wires\n'
    for grid_row in range(0, grid_height - 1):
        next_row = grid_row + 1

        for grid_col in range(0, grid_width):

            cur_tile = 'tile_' + str(grid_row) + '_' + str(grid_col)
            next_tile = 'tile_' + str(next_row) + '_' + str(grid_col)

            for i in range(0, 4):
                body += '\twire vertical_' + cur_tile + '_to_' + next_tile + '_' + str(i) + ';\n'

            for i in range(0, 4):
                body += '\twire vertical_' + next_tile + '_to_' + cur_tile + '_' + str(i) + ';\n'
                
            body += '\n'

    body += '\t// Horizontal wires\n'            
    for grid_col in range(0, grid_width - 1):

        next_col = grid_col + 1

        for grid_row in range(0, grid_height):

            cur_tile = 'tile_' + str(grid_row) + '_' + str(grid_col)
            next_tile = 'tile_' + str(grid_row) + '_' + str(next_col)

            for i in range(0, 4):
                body += '\twire horizontal_' + cur_tile + '_to_' + next_tile + '_' + str(i) + ';\n'

            for i in range(0, 4):
                body += '\twire horizontal_' + next_tile + '_to_' + cur_tile + '_' + str(i) + ';\n'
                
            body += '\n'
            
    # Idea: Utility for helping people draw ascii comment pictures in code

    body += '\t// Tile declarations\n'
    for grid_row in range(0, grid_height):

        prev_row = grid_row - 1
        next_row = grid_row + 1

        for grid_col in range(0, grid_width):

            prev_col = grid_col - 1
            next_col = grid_col + 1

            this_tile = 'tile_' + str(grid_row) + '_' + str(grid_col)
            tile_above = 'tile_' + str(prev_row) + '_' + str(grid_col)
            tile_below = 'tile_' + str(next_row) + '_' + str(grid_col)

            body += '\tpe_tile pe_tile_' + str(grid_row) + '_' + str(grid_col) + '(\n'

            # Wiring up vertical wires

            ## Wiring up tiles to inputs above them: row 0 connects to IOs,
            ## all other rows connect to the row above them
            if ((grid_row == 0) and (grid_col <= (num_in_ios - 1))):
                body += '\t\t.in_wire_3_0(input_to_grid_' + str(grid_col) + '),\n'
            elif (grid_row != 0):
                # All other rows connect to the row above them

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'out_wire_3_' + str(i)
                    body += '\t\t.' + out_wire + '(vertical_' + this_tile + '_to_' + tile_above + '_' + str(i) + '),\n'

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'in_wire_3_' + str(i)
                    body += '\t\t.' + out_wire + '(vertical_' + tile_above + '_to_' + this_tile + '_' + str(i) + '),\n'
                    
            ## Wiring up tiles to inputs below them: row (N - 1) connects to output
            ## IO pads, all other rows connect to row N + 1
            if ((grid_row == (grid_height - 1)) and (grid_col <= (num_out_ios - 1))):
                body += '\t\t.out_wire_1_0(grid_to_output_' + str(grid_col) + '),\n'
            elif (grid_row != (grid_height - 1)):
                for i in range(0, 4):
                    # Connect this tiles side 1 to the next rows tile
                    # side
                    out_wire = 'out_wire_1_' + str(i)
                    body += '\t\t.' + out_wire + '(vertical_' + this_tile + '_to_' + tile_below + '_' + str(i) + '),\n'

                for i in range(0, 4):
                    # Connect this tiles side 1 to the next rows tile
                    # side
                    out_wire = 'in_wire_1_' + str(i)
                    body += '\t\t.' + out_wire + '(vertical_' + tile_below + '_to_' + this_tile + '_' + str(i) + '),\n'
                
                # for wire_no in range(0, 4):
                #     body += '\t\t.out_wire_1_' + str(wire_no) + '(pe_tile_' + str(next_row) + '_' + str(grid_col) + '.in_wire_3_' + str(wire_no) + '),\n'

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
    

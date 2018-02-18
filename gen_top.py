from sets import Set

from generator_utils import module_string

# How do I gradually move to having configuration data determined automatically
# by a bitstream converter?

# Problems:

#   1. Dont want to break unit tests, or if I do I want them to be fixed easily
#   2. Not sure how to deal with connection architecture without just doing string
#      concatenation

# Idea: Convert switch box first (or maybe connect box first?)
# Actually build a class that represents a verilog module. Then add connections
# representing it. Somehow label the configureable portions?

# For now assume: No clock gating. Just clock and reset
# Maybe just build tile based model? Tiles and components. Each with clk / reset,
# other inputs / outputs, switches, clbs and other connections

# switches / clbs need configuration

# Each module has some configurable state. Elaborator looks at the config state,
# computes the number of bits needed, format of bits in config register and
# a mapping from bit patterns in config data to state settings

# Q: How to generate addresses? Tree of components in the top design. Only leaf
#    nodes have configurable elements. Leaf nodes get a config enable bit. Higher
#    level nodes get config addresses

# How to move to this scheme gradually?
# Step one: Start specifying the configuration bit width / layout in data structures
# for each module. Then add a general purpose C++ bitstream converter, and JSON
# bitstream metadata

# Represent structural verilog
# Note: This is basically the yosys representation. No mapping back from wires
# to ports
class VerilogModule():

    def __init__(self, mod_name, ports):
        self.mod_name = mod_name
        self.ports = ports
        self.inst_connections = []
        self.port_connections = []
        self.instances = Set([])
        self.inst_to_wires = {}

    def add_instance(self, mod_name, inst_name):
        self.instances.add((mod_name, inst_name))
        self.inst_to_wires[inst_name] = []

    def add_instance_connection(self, inst_name_0, port_name_0, inst_name_1, port_name_1):
        conn = ((inst_name_0, port_name_0), (inst_name_1, port_name_1))
        self.inst_connections.append(conn)

        w1 = conn[0][0] + '_' + conn[0][1]
        w2 = conn[1][0] + '_' + conn[1][1]
        wire_name = w1 + '_to_' + w2
        
        self.internal_wires.add(wire_name)

        self.inst_to_wires[inst_name_0].append((port_name_0, wire_name))
        self.inst_to_wires[inst_name_1].append((port_name_1, wire_name))

    def add_port_connection(self, module_port_name, inst_name_0, inst_port_name):
        # assert(module_port_name in self.ports)

        self.inst_to_wires[inst_name_0].append((inst_port_name, module_port_name))
        self.port_connections.append((module_port_name, (inst_name_0, inst_port_name)))

    def body_string(self):
        body = ''

        body += '\t// Internal wires\n'
        for conn in self.inst_connections:
            w1 = conn[0][0] + '_' + conn[0][1]
            w2 = conn[1][0] + '_' + conn[1][1]
            body += '\twire ' + w1 + '_to_' + w2 + ';\n'
        body += '\t// End of internal wires\n'

        for inst in self.instances:
            mod_name = inst[0]
            inst_name = inst[1]
            body += '\t' + mod_name + ' ' + inst_name + '(\n'

            print 'inst = ', inst_name
            i = 0
            for port_wire_pair in self.inst_to_wires[inst_name]:
                body += '\t'
                body += '.' + port_wire_pair[0] + '(' + port_wire_pair[1] + ')'
                if i < len(self.inst_to_wires[inst_name]) - 1:
                    body += ','
                body += '\n'
                i += 1
            body += '\t);\n'
        
        return body

def build_top_str(num_in_ios,
                  num_out_ios,
                  grid_height,
                  grid_width):

    assert(num_in_ios <= grid_width)
    assert(num_out_ios <= grid_width)

    includes = ['pe_tile', 'io1in_pad', 'io1out_pad']
    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data']

    for pad_no in range(0, num_in_ios):
        ports.append('input in_wire_' + str(pad_no))

    for pad_no in range(0, num_out_ios):
        ports.append('output out_wire_' + str(pad_no))

    top_mod = VerilogModule('top', ports)

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

    body += '\t// input pads\n'
    for pad_no in range(0, num_in_ios):
        pad_name = 'in_pad_' + str(pad_no)

        top_mod.add_instance('io1in_pad', pad_name)
        top_mod.add_port_connection('clk', pad_name, 'clk')
        top_mod.add_port_connection('in_wire_' + str(pad_no), pad_name, 'top_pin')
        top_mod.add_port_connection('input_to_grid_' + str(pad_no), pad_name, 'pin')

        # body += '\tio1in_pad in_pad_' + str(pad_no) + '(\n'
        # body += '\t\t.clk(clk),\n'
        # body += '\t\t.top_pin(in_wire_' + str(pad_no) + '),\n'
        # body += '\t\t.pin(input_to_grid_' + str(pad_no) + ')\n'
        # body += '\t);\n\n'

    body += '\t// output pads\n'
    for pad_no in range(0, num_out_ios):
        #top_mod.add_instance('io1out_pad', 'out_pad_' + str(pad_no))

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

            tile_left = 'tile_' + str(grid_row) + '_' + str(prev_col)
            tile_right = 'tile_' + str(grid_row) + '_' + str(next_col)

            pe_tile_mod = 'pe_tile'
            if ((grid_col == 0) and (grid_row != 0) and (grid_row != (grid_height - 1))):
                pe_tile_mod = 'pe_tile_left'

            if ((grid_col == (grid_height - 1)) and (grid_row != 0) and (grid_row != (grid_height - 1))):
                pe_tile_mod = 'pe_tile_right'

            if ((grid_row == 0) and (grid_col != 0) and (grid_col != (grid_width - 1))):
                pe_tile_mod = 'pe_tile_top'

            if ((grid_row == 0) and (grid_col == 0)):
                pe_tile_mod = 'pe_tile_top_left'

            if ((grid_row == 0) and (grid_col == (grid_width - 1))):
                pe_tile_mod = 'pe_tile_top_right'

            if ((grid_row == (grid_height - 1)) and (grid_col != (grid_width - 1)) and (grid_col != 0)):
                pe_tile_mod = 'pe_tile_bottom'

            if ((grid_row == (grid_height - 1)) and (grid_col == (grid_width - 1))):
                pe_tile_mod = 'pe_tile_bottom_right'

            if ((grid_row == (grid_height - 1)) and (grid_col == 0)):
                pe_tile_mod = 'pe_tile_bottom_left'

            # Declaration of pe
            tile_name = 'pe_tile_' + str(grid_row) + '_' + str(grid_col)
            # TODO: Re-introduce this value
            # top_mod.add_instance(pe_tile_mod, tile_name)

            body += '\t' + pe_tile_mod + ' ' + tile_name + '(\n'

            
            print 'pe_tile_mod =', pe_tile_mod
            # Wiring up vertical wires

            ## Wiring up tiles to inputs above them: row 0 connects to IOs,
            ## all other rows connect to the row above them
            if ((grid_row == 0) and (grid_col <= (num_in_ios - 1))):
                body += '\t\t.in_wire_3_0(input_to_grid_' + str(grid_col) + '),\n'

                for i in range(1, 4):
                    body += '\t\t.in_wire_3_' + str(i) + '(1\'b0),\n'

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

                for i in range(0, 4):
                    body += '\t\t.in_wire_1_' + str(i) + '(1\'b0),\n'

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

            # Wiring up horizontal grid
            # If this is not column 0 connects to tiles to the left
            if (grid_col != 0):
                for i in range(0, 4):
                    # Connect this tiles side 2 to the tile to the left
                    out_wire = 'out_wire_2_' + str(i)
                    body += '\t\t.' + out_wire + '(horizontal_' + this_tile + '_to_' + tile_left + '_' + str(i) + '),\n'

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'in_wire_2_' + str(i)
                    body += '\t\t.' + out_wire + '(horizontal_' + tile_left + '_to_' + this_tile + '_' + str(i) + '),\n'

            else:
                for i in range(0, 4):
                    out_wire = 'in_wire_2_' + str(i)
                    body += '\t\t.' + out_wire + '(1\'b0),\n'
                

            if (grid_col != (grid_width - 1)):
                for i in range(0, 4):
                    # Connect this tiles side 0 to the column to the right
                    out_wire = 'out_wire_0_' + str(i)
                    body += '\t\t.' + out_wire + '(horizontal_' + this_tile + '_to_' + tile_right + '_' + str(i) + '),\n'

                for i in range(0, 4):
                    out_wire = 'in_wire_0_' + str(i)
                    body += '\t\t.' + out_wire + '(horizontal_' + tile_right + '_to_' + this_tile + '_' + str(i) + '),\n'
            else:
                for i in range(0, 4):
                    out_wire = 'in_wire_0_' + str(i)
                    body += '\t\t.' + out_wire + '(1\'b0),\n'
            
            body += '\t\t.clk(clk),\n'
            body += '\t\t.reset(reset),\n'
            body += '\t\t.config_addr(config_addr),\n'
            body += '\t\t.config_data(config_data),\n'
            body += '\t\t.tile_id(' + str(tile_id) + ')\n'

            body += '\t);\n\n'
            tile_id += 1

    return module_string(includes, 'top', ports, top_mod.body_string() + '\n' + body)
    #return module_string(includes, 'top', ports, body)


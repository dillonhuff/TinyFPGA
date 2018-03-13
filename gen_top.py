from sets import Set

from generator_utils import module_string

# Represent structural verilog + assignments

# Note: This is basically the yosys representation. No mapping back from wires
# to ports

# Note: Need to add input / output types on ports

# Note: tile to tile_id mappings are major piece of configurable state that is
# needed for this generator. After that we will need the mapping from tile names
# to tile type names. Also we are going to need tileIdStart, tileIdEnd,
# componentIdStart, componentIdEnd

# Q: What is the next small step toward a consistent, unified set of generators?
# Q: What am I trying to get to? A design where all json is generated uniformly
#    by each generate call and stored to a single json file. Verilog is generated
#    file by file (or all at once I guess would work too)
class VerilogModule():

    def __init__(self, mod_name, ports):
        self.mod_name = mod_name
        self.ports = ports

        self.metadata = {}
        self.instances = Set([])
        self.inst_to_wires = {}
        self.internal_wires = Set([])
        self.assigns = Set([])
        self.wire_widths = {}

    def add_wire(self, wire_name, width=1):
        self.internal_wires.add(wire_name)
        self.wire_widths[wire_name] = width

    def add_instance(self, mod_name, inst_name):
        self.instances.add((mod_name, inst_name))
        self.inst_to_wires[inst_name] = []

    def add_assign(self, in_wire, driver_value):
        assert(in_wire in self.internal_wires)
        self.assigns.add((in_wire, driver_value))

    def add_instance_connection(self, inst_name_0, port_name_0, inst_name_1, port_name_1):
        conn = ((inst_name_0, port_name_0), (inst_name_1, port_name_1))

        w1 = conn[0][0] + '_' + conn[0][1]
        w2 = conn[1][0] + '_' + conn[1][1]
        wire_name = w1 + '_to_' + w2

        self.add_wire(wire_name)

        self.inst_to_wires[inst_name_0].append((port_name_0, wire_name))
        self.inst_to_wires[inst_name_1].append((port_name_1, wire_name))

    def add_port_connection(self, module_port_name, inst_name_0, inst_port_name):
        # assert(module_port_name in self.ports)

        self.inst_to_wires[inst_name_0].append((inst_port_name, module_port_name))

    # same as add port connection. Merge or add check for port to add_port_connection?
    def add_wire_connection(self, wire_name, inst_name_0, inst_port_name):
        assert(wire_name in self.internal_wires)
        self.inst_to_wires[inst_name_0].append((inst_port_name, wire_name))
        
    def body_string(self):
        body = ''

        body += '\t// Internal wires\n'
        for wire in self.internal_wires:
            width = self.wire_widths[wire]
            body += '\twire [' + str(width) + ' - 1 : 0] ' + wire + ';\n'
        body += '\t// End of internal wires\n'

        for inst in self.instances:
            mod_name = inst[0]
            inst_name = inst[1]
            body += '\t' + mod_name + ' ' + inst_name + '(\n'

            print 'inst = ', inst_name
            i = 0
            for port_wire_pair in self.inst_to_wires[inst_name]:
                body += '\t\t'
                body += '.' + port_wire_pair[0] + '(' + port_wire_pair[1] + ')'
                if i < len(self.inst_to_wires[inst_name]) - 1:
                    body += ','
                body += '\n'
                i += 1
            body += '\t);\n'

        body += '\t// Assignments \n'
        for assign in self.assigns:
            body += '\tassign ' + assign[0] + ' = ' + assign[1] + ';\n'
        
        return body

def build_top_mod(num_in_ios,
                  num_out_ios,
                  grid_height,
                  grid_width):

    assert(num_in_ios <= grid_width)
    assert(num_out_ios <= grid_width)

    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data']

    for pad_no in range(0, num_in_ios):
        ports.append('input in_wire_' + str(pad_no))

    for pad_no in range(0, num_out_ios):
        ports.append('output out_wire_' + str(pad_no))

    top_mod = VerilogModule('top', ports)

    for pad_no in range(0, num_in_ios):
        pad_name = 'in_pad_' + str(pad_no)

        top_mod.add_instance('io1in_pad', pad_name)
        top_mod.add_port_connection('clk', pad_name, 'clk')
        top_mod.add_port_connection('in_wire_' + str(pad_no), pad_name, 'top_pin')

    for pad_no in range(0, num_out_ios):
        pad_name = 'out_pad_' + str(pad_no)

        top_mod.add_instance('io1out_pad', pad_name)
        top_mod.add_port_connection('out_wire_' + str(pad_no), pad_name, 'top_pin')
        top_mod.add_port_connection('clk', pad_name, 'clk')

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

    for grid_row in range(0, grid_height - 1):
        next_row = grid_row + 1

        for grid_col in range(0, grid_width):

            cur_tile = 'tile_' + str(grid_row) + '_' + str(grid_col)
            next_tile = 'tile_' + str(next_row) + '_' + str(grid_col)

            for i in range(0, 4):
                top_mod.add_wire('vertical_' + cur_tile + '_to_' + next_tile + '_' + str(i))
            for i in range(0, 4):
                top_mod.add_wire('vertical_' + next_tile + '_to_' + cur_tile + '_' + str(i))

    for grid_col in range(0, grid_width - 1):

        next_col = grid_col + 1

        for grid_row in range(0, grid_height):

            cur_tile = 'tile_' + str(grid_row) + '_' + str(grid_col)
            next_tile = 'tile_' + str(grid_row) + '_' + str(next_col)

            for i in range(0, 4):
                top_mod.add_wire('horizontal_' + cur_tile + '_to_' + next_tile + '_' + str(i))

            for i in range(0, 4):
                top_mod.add_wire('horizontal_' + next_tile + '_to_' + cur_tile + '_' + str(i))

    tiles_to_ids = {}
    tile_map = {}
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
            top_mod.add_instance(pe_tile_mod, tile_name)
            tile_map[tile_name] = pe_tile_mod

            print 'pe_tile_mod =', pe_tile_mod
            # Wiring up vertical wires

            ## Wiring up tiles to inputs above them: row 0 connects to IOs,
            ## all other rows connect to the row above them
            if ((grid_row == 0) and (grid_col <= (num_in_ios - 1))):
                top_mod.add_instance_connection('in_pad_' + str(grid_col),
                                                'pin',
                                                tile_name,
                                                'in_wire_3_0')

                # Q: How do we replace these connections?
                for i in range(1, 4):
                    in_wire = tile_name + '_in_wire_3_' + str(i) + '_const'
                    top_mod.add_wire(in_wire)
                    top_mod.add_wire_connection(in_wire, tile_name, 'in_wire_3_' + str(i))
                    top_mod.add_assign(in_wire, '1\'b0')

            elif (grid_row != 0):
                # All other rows connect to the row above them

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'out_wire_3_' + str(i)
                    connector = 'vertical_' + this_tile + '_to_' + tile_above + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'in_wire_3_' + str(i)
                    connector = 'vertical_' + tile_above + '_to_' + this_tile + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)
                    
            ## Wiring up tiles to inputs below them: row (N - 1) connects to output
            ## IO pads, all other rows connect to row N + 1
            if ((grid_row == (grid_height - 1)) and (grid_col <= (num_out_ios - 1))):
                top_mod.add_instance_connection('out_pad_' + str(grid_col),
                                                'pin',
                                                tile_name,
                                                'out_wire_1_0')

                for i in range(0, 4):
                    in_wire = 'in_wire_1_' + str(i)
                    in_wire_c = tile_name + '_' + in_wire + '_const'
                    top_mod.add_wire(in_wire_c)
                    top_mod.add_wire_connection(in_wire_c, tile_name, in_wire)
                    top_mod.add_assign(in_wire_c, '1\'b0')

            elif (grid_row != (grid_height - 1)):
                for i in range(0, 4):
                    # Connect this tiles side 1 to the next rows tile
                    # side
                    out_wire = 'out_wire_1_' + str(i)
                    connector = 'vertical_' + this_tile + '_to_' + tile_below + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

                for i in range(0, 4):
                    # Connect this tiles side 1 to the next rows tile
                    # side
                    out_wire = 'in_wire_1_' + str(i)
                    connector = 'vertical_' + tile_below + '_to_' + this_tile + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

            # Wiring up horizontal grid
            # If this is not column 0 connects to tiles to the left
            if (grid_col != 0):
                for i in range(0, 4):
                    # Connect this tiles side 2 to the tile to the left
                    out_wire = 'out_wire_2_' + str(i)
                    connector = 'horizontal_' + this_tile + '_to_' + tile_left + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

                for i in range(0, 4):
                    # Connect this tiles side 3 to the previous rows tile
                    # side
                    out_wire = 'in_wire_2_' + str(i)
                    connector = 'horizontal_' + tile_left + '_to_' + this_tile + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

            else:
                for i in range(0, 4):
                    out_wire = 'in_wire_2_' + str(i)
                    out_wire_c = tile_name + out_wire + '_const'

                    top_mod.add_wire(out_wire_c)
                    top_mod.add_wire_connection(out_wire_c, tile_name, out_wire)
                    top_mod.add_assign(out_wire_c, '1\'b0')
                

            if (grid_col != (grid_width - 1)):
                for i in range(0, 4):
                    # Connect this tiles side 0 to the column to the right
                    out_wire = 'out_wire_0_' + str(i)
                    connector = 'horizontal_' + this_tile + '_to_' + tile_right + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)

                for i in range(0, 4):
                    out_wire = 'in_wire_0_' + str(i)
                    connector = 'horizontal_' + tile_right + '_to_' + this_tile + '_' + str(i)
                    top_mod.add_wire_connection(connector, tile_name, out_wire)
            else:
                for i in range(0, 4):
                    out_wire = 'in_wire_0_' + str(i)
                    out_wire_c = tile_name + '_in_wire_0_' + str(i) + '_const'
                    res = '1\'b0'
                    top_mod.add_wire(out_wire_c)
                    top_mod.add_wire_connection(out_wire_c, tile_name, out_wire)
                    top_mod.add_assign(out_wire_c, '1\'b0')

            top_mod.add_port_connection('clk', tile_name, 'clk')
            top_mod.add_port_connection('reset', tile_name, 'reset')
            top_mod.add_port_connection('config_addr', tile_name, 'config_addr')
            top_mod.add_port_connection('config_data', tile_name, 'config_data')

            tile_id_wire = tile_name + '_id_wire'
            top_mod.add_wire(tile_id_wire, 16)
            top_mod.add_assign(tile_id_wire, str(tile_id))
            top_mod.add_port_connection(tile_id_wire, tile_name, 'tile_id')

            tiles_to_ids[tile_name] = tile_id
            tile_id += 1

    top_mod.metadata['tile_id_end'] = 15
    top_mod.metadata['tile_id_start'] = 0
    top_mod.metadata['mod_id_end'] = 31
    top_mod.metadata['mod_id_start'] = 16
    top_mod.metadata['tiles_to_ids'] = tiles_to_ids
    top_mod.metadata['tile_map'] = tile_map
    top_mod.metadata['config_data_width'] = 32
    
    return top_mod

def build_top_mod_bitstream_json(top_mod):
    return top_mod.metadata

def build_top_mod_topology_json(top_mod):
    top_json = {}
    return top_json

def build_verilog_string(top_mod):
    includes = ['pe_tile', 'io1in_pad', 'io1out_pad']
    return module_string(includes, top_mod.mod_name, top_mod.ports, top_mod.body_string())


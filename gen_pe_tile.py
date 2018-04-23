from sets import Set

import json

from generator_utils import module_string
from verilog import VerilogModule, VerilogModuleInstance

# Note: Place and router needs more info if it is going to generate a
# string format object that communicates with the bitstream converter
# For now the PnR and bitstream converter should probably be in the
# same repo.

# Note: The PnR will have to remove wires and move to a pointwise format
# from the wire based format of the current design.

# Q: How to build the switch box, connect box, and CLB implementations?
# Maybe have some base programmable modules? Switch and black box that all
# modules get reduced to?

# Q: Name compatibility with bitstream is also crucial. Do switch names match up?

# Q: How am I going to test this? Create a test where I:
#    1. Generate an 3 x 3 FPGA design with PnR + bitstream metadata
#    2. Build an application graph for the FPGA
#    3. Build the PnR tool + bitstream tool
#    4. Test the application in verilator
#    5. Fail out if the application crashes or does not do what Im expecting

# Probably this stuff should be coordinated in python

class ProgrammableModule:
    def __init__(self, module_name, inst_name, connections):
        self.module_name = module_name
        self.inst_name = inst_name
        self.connections = connections

    def connect(self, port, wire):
        self.connections[port] = wire

    def set_config_id(self, config_id):
        self.config_id = config_id

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

class PETile:
    def __init__(self,
                 mod_name,
                 switch_box_mod,
                 sides_to_use,
                 n_sides,
                 n_wires_per_side):

        self.mod_name = mod_name
        self.switch_box_mod = switch_box_mod

        self.input_wires = Set([])
        for side in range(0, n_sides):
            for wire in range(0, n_wires_per_side):
                self.input_wires.add('input in_wire_' + str(side) + '_' + str(wire))

        self.output_wires = Set([])
        for side in range(0, n_sides):
            if side in sides_to_use:
                for wire in range(0, n_wires_per_side):
                    self.output_wires.add('output out_wire_' + str(side) + '_' + str(wire))

        if not (1 in sides_to_use):
            self.output_wires.add('output out_wire_1_0')

        self.local_output_wires = Set([])
        if not (0 in sides_to_use):
            for wire in range(0, n_wires_per_side):
                self.local_output_wires.add('wire out_wire_0_' + str(wire))

        if not (1 in sides_to_use):
            for wire in range(1, n_wires_per_side):
                self.local_output_wires.add('wire out_wire_1_' + str(wire))

        self.modules = {}
        self.modules['cb0'] = ProgrammableModule('connect_box',
                                                 'cb0',
                                                 {})

        for wire in range(0, n_wires_per_side):
            self.modules['cb0'].connect('track' + str(wire) + '_in', 'in_wire_0_' + str(wire))

        for wire in range(n_wires_per_side, 2*n_wires_per_side):
            wire_no = wire - n_wires_per_side
            self.modules['cb0'].connect('track' + str(wire) + '_in', 'out_wire_0_' + str(wire_no))

        self.modules['cb0'].connect('block_out', 'op_0')
        self.modules['cb0'].connect('config_en', 'config_en_cb0')
        self.modules['cb0'].connect('config_data', 'config_data[2:0]')
        self.modules['cb0'].connect('clk', 'clk')

        self.modules['cb1'] = ProgrammableModule('connect_box', 'cb1', {})

        cb1 = self.modules['cb1']
        for wire in range(0, n_wires_per_side):
            cb1.connect('track' + str(wire) + '_in', 'in_wire_1_' + str(wire))

        for wire in range(n_wires_per_side, 2*n_wires_per_side):
            wire_no = wire - n_wires_per_side
            cb1.connect('track' + str(wire) + '_in', 'out_wire_1_' + str(wire_no))
        
        cb1.connect('block_out', 'op_1')
        cb1.connect('config_en', 'config_en_cb1')
        cb1.connect('config_data', 'config_data[2:0]')
        cb1.connect('clk', 'clk')

        self.modules['sb'] = ProgrammableModule(switch_box_mod, 'sb', {})
        sb = self.modules['sb']
        for side_no in range(0, n_sides):
            for wire_no in range(0, n_wires_per_side):
                port_name = 'in_wire_' + str(side_no) + '_' + str(wire_no)
                sb.connect(port_name, port_name)

        for side_no in range(0, n_sides):
            # Outputs from side 0 and 1 are always routed to the connect boxes so
            # they are always needed
            if (side_no in sides_to_use) or (side_no in [0, 1]):
                for wire_no in range(0, n_wires_per_side):
                    port_name = 'out_wire_' + str(side_no) + '_' + str(wire_no)
                    sb.connect(port_name, port_name)

        sb.connect('pe_output_0', 'pe_output')
        sb.connect('config_data', 'config_data')
        sb.connect('config_en', 'config_en_sb')
        sb.connect('clk', 'clk')
        sb.connect('reset', 'reset')

        self.modules['compute_block'] = ProgrammableModule('clb', 'compute_block', {})
        clb = self.modules['compute_block']
        clb.connect('in0', 'op_0')
        clb.connect('in1', 'op_1')
        clb.connect('clk', 'clk')
        clb.connect('config_enable', 'config_en_compute_block')
        clb.connect('config_data', 'config_data[1:0]')
        clb.connect('out', 'pe_output')


        # Set configuration info for each programmable module
        # Eventually this will be automated
        self.modules['sb'].set_config_id(7)
        self.modules['cb0'].set_config_id(6)
        self.modules['cb1'].set_config_id(5)
        self.modules['compute_block'].set_config_id(4)

        self.tile_id_end = 15
        self.tile_id_begin = 0
        self.mod_id_end = 31
        self.mod_id_begin = 16

# Problem is that this does not include any connections between modules
# I need to add every connection to the metadata.

# Really I would like for everything to be standard structural verilog
def generate_pe_tile_json(pe_tile):
    json_val = {}

    # json_val['mod_name'] = pe_tile.mod_name

    # # json_val['tile_name'] = pe_tile.inst_name

    # # TODO: Need to serialize module names at least
    # # json_val['modules'] = pe_tile.modules
    
    # json_val['switch_box_mod'] = pe_tile.switch_box_mod

    # json_val['input_wires'] = list(pe_tile.input_wires)
    # json_val['output_wires'] = list(pe_tile.output_wires)

    # json_val['local_output_wires'] = list(pe_tile.local_output_wires)

    return json_val

# Note: perhaps the connect box should be attached to outputs? or to both inputs and
# outputs?

def generate_pe_verilog(mod_name, switch_box_mod, sides_to_use, n_sides, n_wires_per_side):
    mod = VerilogModule(mod_name)

    mod.add_wire('clk', False, True, 'input', 1)
    mod.add_wire('reset', False, True, 'input', 1)
    mod.add_wire('config_addr', False, True, 'input', 32)
    mod.add_wire('config_data', False, True, 'input', 32)
    mod.add_wire('tile_id', False, True, 'input', 16)

    for side in range(0, n_sides):
        for wire in range(0, n_wires_per_side):
            mod.add_wire('in_wire_' + str(side) + '_' + str(wire), False, True, 'input', 1)

    for side in range(0, n_sides):
        if side in sides_to_use or (side == 0) or (side == 1):
            for wire in range(0, n_wires_per_side):
                mod.add_wire('out_wire_' + str(side) + '_' + str(wire), False, True, 'output', 1)

    mod.add_wire('op_0', False, False, '', 1)
    mod.add_wire('op_1', False, False, '', 1)
    mod.add_wire('pe_output', False, False, '', 1)

    # TODO: Add real tile ids

    mod.add_instance('slice_mod', 'cb0_slice', {'start_ind' : 0, 'end_ind' : 2})
    mod.add_wire_connection('config_addr', 'cb0_slice', 'in')
    mod.add_wire('cb0_config_data', False, False, '', 3)
    mod.add_wire_connection('cb0_config_data', 'cb0_slice', 'out')

    mod.add_instance('slice_mod', 'cb1_slice', {'start_ind' : 0, 'end_ind' : 2})
    mod.add_wire_connection('config_addr', 'cb1_slice', 'in')
    mod.add_wire('cb1_config_data', False, False, '', 3)
    mod.add_wire_connection('cb1_config_data', 'cb1_slice', 'out')

    mod.add_instance('slice_mod', 'clb_slice', {'start_ind' : 0, 'end_ind' : 1})
    mod.add_wire_connection('config_addr', 'clb_slice', 'in')
    mod.add_wire('clb_config_data', False, False, '', 2)
    mod.add_wire_connection('clb_config_data', 'clb_slice', 'out')

    tile_id_end = 15
    tile_id_begin = 0
    mod_id_end = 31
    mod_id_begin = 16

    mod.add_wire('config_en_cb0', False, False, '', 1)
    mod.add_instance('address_matcher', 'cb0_address_matcher', {'config_flag_value' : 6, 'tile_id_end' : tile_id_end, 'tile_id_begin' : tile_id_begin, 'mod_id_end' : mod_id_end, 'mod_id_begin' : mod_id_begin})
    mod.add_wire_connection('config_en_cb0', 'cb0_address_matcher', 'config_reg')
    mod.add_wire_connection('tile_id', 'cb0_address_matcher', 'tile_id')
    mod.add_wire_connection('config_addr', 'cb0_address_matcher', 'config_addr')


    mod.add_wire('config_en_cb1', False, False, '', 1)
    mod.add_instance('address_matcher', 'cb1_address_matcher', {'config_flag_value' : 5, 'tile_id_end' : tile_id_end, 'tile_id_begin' : tile_id_begin, 'mod_id_end' : mod_id_end, 'mod_id_begin' : mod_id_begin})    
    mod.add_wire_connection('config_en_cb1', 'cb1_address_matcher', 'config_reg')
    mod.add_wire_connection('tile_id', 'cb1_address_matcher', 'tile_id')
    mod.add_wire_connection('config_addr', 'cb1_address_matcher', 'config_addr')


    mod.add_wire('config_en_sb', False, False, '', 1)
    mod.add_instance('address_matcher', 'sb_address_matcher', {'config_flag_value' : 7, 'tile_id_end' : tile_id_end, 'tile_id_begin' : tile_id_begin, 'mod_id_end' : mod_id_end, 'mod_id_begin' : mod_id_begin})        
    #mod.add_instance('address_matcher', 'sb_address_matcher', {'config_id' : 1})
    mod.add_wire_connection('config_en_sb', 'sb_address_matcher', 'config_reg')
    mod.add_wire_connection('tile_id', 'sb_address_matcher', 'tile_id')
    mod.add_wire_connection('config_addr', 'sb_address_matcher', 'config_addr')

    mod.add_wire('config_en_logic_block', False, False, '', 1)
    mod.add_instance('address_matcher', 'logic_block_address_matcher', {'config_flag_value' : 4, 'tile_id_end' : tile_id_end, 'tile_id_begin' : tile_id_begin, 'mod_id_end' : mod_id_end, 'mod_id_begin' : mod_id_begin})            
    #mod.add_instance('address_matcher', 'logic_block_address_matcher', {'config_id' : 1})
    mod.add_wire_connection('config_en_logic_block', 'logic_block_address_matcher', 'config_reg')
    mod.add_wire_connection('tile_id', 'logic_block_address_matcher', 'tile_id')
    mod.add_wire_connection('config_addr', 'logic_block_address_matcher', 'config_addr')

    mod.add_wire('pe_output', False, False, '', 1)

    mod.add_instance('connect_box', 'cb0')
    mod.add_wire_connection('config_en_cb0', 'cb0', 'config_en')
    mod.add_wire_connection('op_0', 'cb0', 'block_out')
    mod.add_wire_connection('cb0_config_data', 'cb0', 'config_data')
    
    mod.add_instance('connect_box', 'cb1')
    mod.add_wire_connection('config_en_cb1', 'cb1', 'config_en')
    mod.add_wire_connection('op_1', 'cb1', 'block_out')
    mod.add_wire_connection('cb1_config_data', 'cb1', 'config_data')

    mod.add_instance(switch_box_mod, 'sb')
    mod.add_wire_connection('config_en_sb', 'sb', 'config_en')
    mod.add_wire_connection('config_data', 'sb', 'config_data')
    mod.add_wire_connection('pe_output', 'sb', 'pe_output_0')

    mod.add_instance('clb', 'logic_block')
    mod.add_wire_connection('config_en_logic_block', 'logic_block', 'config_enable')
    mod.add_wire_connection('op_0', 'logic_block', 'in0')
    mod.add_wire_connection('op_1', 'logic_block', 'in1')
    mod.add_wire_connection('pe_output', 'logic_block', 'out')
    mod.add_wire_connection('clb_config_data', 'logic_block', 'config_data')

    mod.add_wire_connection('reset', 'sb', 'reset')
    
    mod.add_wire_connection('clk', 'cb0', 'clk')
    mod.add_wire_connection('clk', 'cb1', 'clk')
    mod.add_wire_connection('clk', 'sb', 'clk')
    mod.add_wire_connection('clk', 'logic_block', 'clk')

    for side_no in range(0, n_sides):
        for wire_no in range(0, n_wires_per_side):
            port_name = 'in_wire_' + str(side_no) + '_' + str(wire_no)
            #mod.add_wire(port_name, False, True, '', 1)
            mod.add_wire_connection(port_name, 'sb', port_name)

    for side_no in range(0, n_sides):
        # Outputs from side 0 and 1 are always routed to the connect boxes so
        # they are always needed
        if (side_no in sides_to_use) or (side_no in [0, 1]):
            for wire_no in range(0, n_wires_per_side):
                port_name = 'out_wire_' + str(side_no) + '_' + str(wire_no)
                #mod.add_wire(port_name, False, True, '', 1)
                mod.add_wire_connection(port_name, 'sb', port_name)
    
    for wire in range(0, n_wires_per_side):
        wire_name = 'track' + str(wire) + '_in'
        in_wire = 'in_wire_0_' + str(wire)
        #mod.add_wire(in_wire, False, True, '', 1)
        mod.add_wire_connection(in_wire, 'cb0', wire_name)

    for wire in range(n_wires_per_side, 2*n_wires_per_side):
        wire_no = wire - n_wires_per_side
        wire_name = 'track' + str(wire) + '_in'
        #in_wire = 'out_wire_0_' + str(wire_no)
        #mod.add_wire(in_wire, False, True, '', 1)

        mod.add_wire_connection(in_wire, 'cb0', wire_name)

    for wire in range(0, n_wires_per_side):
        wire_name = 'track' + str(wire) + '_in'
        in_wire = 'in_wire_0_' + str(wire)
        #mod.add_wire(in_wire, False, True, '', 1)
        mod.add_wire_connection(in_wire, 'cb1', wire_name)

    for wire in range(n_wires_per_side, 2*n_wires_per_side):
        wire_no = wire - n_wires_per_side
        wire_name = 'track' + str(wire) + '_in'
        in_wire = 'out_wire_0_' + str(wire_no)
        #mod.add_wire(in_wire, False, True, '', 1)

        mod.add_wire_connection(in_wire, 'cb1', wire_name)
        
    return mod

# Need to add custom modules for configuration state and for assignment
def generate_pe_tile_verilog(pe_tile):

    ports = ['input clk', 'input reset', 'input [31:0] config_addr', 'input [31:0] config_data', 'input [15:0] tile_id']

    for in_wire in pe_tile.input_wires:
        ports.append(in_wire)

    for out_wire in pe_tile.output_wires:
        ports.append(out_wire)

    body = '\n'

    body += '\twire op_0;\n'
    body += '\twire op_1;\n'
    body += '\t/* verilator lint_off UNOPTFLAT */\n'
    body += '\twire pe_output;\n\n'

    body += '\t// Local wires for switch box outputs <-> connect box\n'
    for wire in pe_tile.local_output_wires:
        body += '\t' + wire + ';\n'

    for mod_name in pe_tile.modules:
        mod = pe_tile.modules[mod_name]
        body += '\t// Set configuration flag\n'

        config_reg = 'config_en_' + mod.inst_name
        config_flag_value = 'CONFIG_' + mod.inst_name
        body += '\treg ' + config_reg + ';\n'
        body += '\tlocalparam ' + config_flag_value + ' = ' + str(mod.config_id) + ';\n'
        body += '\talways @(*) begin\n'
        body += '\t\tif ((config_addr[' + str(pe_tile.tile_id_end) + ':' + str(pe_tile.tile_id_begin) + '] == tile_id) && (config_addr[' + str(pe_tile.mod_id_end) + ':' + str(pe_tile.mod_id_begin) + '] == ' + config_flag_value + ')) begin\n'
        body += '\t\t\t' + config_reg + ' = 1\'b1;\n'
        body += '\t\tend else begin\n'
        body += '\t\t\t' + config_reg + ' = 1\'b0;\n'
        body += '\t\tend\n'
        body += '\tend\n\n'

        body += '\n\n'

        body += '\t// Declare module\n'
        body += '\t' + mod.module_name + ' ' + mod.inst_name + '(\n'

        i = 0
        for port in mod.connections:
            body += '\t\t.' + port + '(' + mod.connections[port] + ')'
            if (i < (len(mod.connections) - 1)):
                body += ','
            body += '\n'
            i += 1
        
        body += '\t);\n\n'

    return module_string(['clb.v', 'connect_box.v', 'switch_box.v'],
                         pe_tile.mod_name,
                         ports,
                         body)

def generate_pe_bs_json(pe_tile):
    json_val = {}
    # mod_map = {'cb0' : 'connect_box', 'cb1' : 'connect_box', 'compute_block' : 'clb', 'sb' : pe_tile.switch_box_mod}

    # mods_to_addrs = {}
    # mods_to_addrs['sb'] = pe_tile.modules['sb'].config_id
    # mods_to_addrs['cb0'] = pe_tile.modules['cb0'].config_id
    # mods_to_addrs['cb1'] = pe_tile.modules['cb1'].config_id
    # mods_to_addrs['compute_block'] = pe_tile.modules['compute_block'].config_id

    # json_val['mods_to_addrs'] = mods_to_addrs

    # json_val['mod_map'] = mod_map
    return json_val

def generate_pe_tile(mod_name,
                     switch_box_mod,
                     sides_to_use,
                     n_sides,
                     n_wires_per_side):
    #pe_tile = PETile(mod_name, switch_box_mod, sides_to_use, n_sides, n_wires_per_side)
    # Creating real pe tile
    pe_tile = generate_pe_verilog(mod_name, switch_box_mod, sides_to_use, n_sides, n_wires_per_side)
    
    verilog_str = pe_tile.module_string() #generate_pe_tile_verilog(pe_tile)
    pe_tile_file = open(mod_name + '.v', 'w')
    pe_tile_file.write(verilog_str)
    pe_tile_file.close()

    return (generate_pe_bs_json(pe_tile), generate_pe_tile_json(pe_tile))

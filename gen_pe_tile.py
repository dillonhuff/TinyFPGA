from sets import Set

import json

from generator_utils import module_string
from verilog import VerilogModule, VerilogModuleInstance

# Note: Place and router needs more info if it is going to generate a
# string format object that communicates with the bitstream converter
# For now the PnR and bitstream converter should probably be in the
# same repo.

# Now need a way to send config info to PnR.
# Need to include: metadata with verilog modules about how they are supposed to
# be labeled. Also need to include info about the topology of each component.
# I might need a namespace-like concept for this so that when generating JSON
# for the topology I can know when to stop. Will I need to stop? Just dont
# generate topology json for hand-written modules

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

# TODO: Add out_1_0 wire to bottom tiles!

# Really a few different data structures to express topology
# Switch box inputs / outputs
# PE tile inputs / outputs
# Each of these is an instance
# Really the data structure needs to express
# 1. Inputs on each side
# 2. Outputs on each side
# 3. How inputs connect to outputs
# 4. Need labels for which wires are ports and which are internal wires
def generate_pe_verilog(mod_name, switch_box_mod, sides_to_use, n_sides, n_wires_per_side, is_bottom):
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

            if (side == 1) and not (side in sides_to_use):

                if is_bottom:
                    mod.add_wire('out_wire_' + str(side) + '_0', False, True, 'output', 1)
                    for wire in range(1, n_wires_per_side):
                        mod.add_wire('out_wire_' + str(side) + '_' + str(wire), False, False, 'output', 1)
                        
                else:
                    for wire in range(0, n_wires_per_side):
                        mod.add_wire('out_wire_' + str(side) + '_' + str(wire), False, False, 'output', 1)

            elif (side == 0) and not (side in sides_to_use):
                for wire in range(0, n_wires_per_side):
                    mod.add_wire('out_wire_' + str(side) + '_' + str(wire), False, False, 'output', 1)

            else:
                for wire in range(0, n_wires_per_side):
                    mod.add_wire('out_wire_' + str(side) + '_' + str(wire), False, True, 'output', 1)

    mod.add_wire('op_0', False, False, '', 1)
    mod.add_wire('op_1', False, False, '', 1)
    mod.add_wire('pe_output', False, False, '', 1)

    # TODO: Add real tile ids

    mod.add_instance('slice_mod', 'cb0_slice', {'start_ind' : 0, 'end_ind' : 2})
    mod.add_wire_connection('config_data', 'cb0_slice', 'in')
    mod.add_wire('cb0_config_data', False, False, '', 3)
    mod.add_wire_connection('cb0_config_data', 'cb0_slice', 'out')

    mod.add_instance('slice_mod', 'cb1_slice', {'start_ind' : 0, 'end_ind' : 2})
    mod.add_wire_connection('config_data', 'cb1_slice', 'in')
    mod.add_wire('cb1_config_data', False, False, '', 3)
    mod.add_wire_connection('cb1_config_data', 'cb1_slice', 'out')

    mod.add_instance('slice_mod', 'clb_slice', {'start_ind' : 0, 'end_ind' : 1})
    mod.add_wire_connection('config_data', 'clb_slice', 'in')
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
                mod.add_wire_connection(port_name, 'sb', port_name)
    
    for wire in range(0, n_wires_per_side):
        wire_name = 'track' + str(wire) + '_in'
        in_wire = 'in_wire_0_' + str(wire)
        mod.add_wire_connection(in_wire, 'cb0', wire_name)

    for wire in range(n_wires_per_side, 2*n_wires_per_side):
        wire_no = wire - n_wires_per_side
        wire_name = 'track' + str(wire) + '_in'
        out_wire = 'out_wire_0_' + str(wire_no)
        mod.add_wire_connection(out_wire, 'cb0', wire_name)

    for wire in range(0, n_wires_per_side):
        wire_name = 'track' + str(wire) + '_in'
        in_wire = 'in_wire_1_' + str(wire)
        mod.add_wire_connection(in_wire, 'cb1', wire_name)

    for wire in range(n_wires_per_side, 2*n_wires_per_side):
        wire_no = wire - n_wires_per_side
        wire_name = 'track' + str(wire) + '_in'
        out_wire = 'out_wire_1_' + str(wire_no)

        mod.add_wire_connection(out_wire, 'cb1', wire_name)
        
    return mod

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
                     n_wires_per_side,
                     is_bottom=False):
    # Creating real pe tile
    pe_tile = generate_pe_verilog(mod_name, switch_box_mod, sides_to_use, n_sides, n_wires_per_side, is_bottom)
    
    verilog_str = pe_tile.module_string()
    pe_tile_file = open(mod_name + '.v', 'w')
    pe_tile_file.write(verilog_str)
    pe_tile_file.close()

    return (generate_pe_bs_json(pe_tile), generate_pe_tile_json(pe_tile))

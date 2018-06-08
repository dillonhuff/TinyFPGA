from gen_switch_box import build_mod_str, generate_sb
from gen_pe_tile import generate_pe_tile
from gen_top import build_verilog_string, build_top_mod, build_top_mod_bitstream_json,build_top_mod_topology_json
import json

# Note: The bitstream format does not need the full connection network info, so
# all of the connections in gen_top dont need to be included to generate the bitstream
# However, PnR needs all of those connections, so they will have to be included
# in the object eventually.

# Now: How to emit json for the target topology?
# Emit modules with labels? Each module has a module name, a list of ports
# and a definition. The definition includes:
#  1. List of submodules
#  2. Connections between ports on submodules
#  3. List of programmable elements in the base modules?
#  4. List of labels in the base modules? E.G. CLB modes?
# Leave it to the place and route software to decompress each module?

# Really need a more general way to describe the topology. Should be able to
# generate one bottom wire without special flags.
def run_generators(grid_len):
    bitstream_json = {}
    topology_json = {}

    n_wires_per_side = 4
    # Center switch box
    sb_json = generate_sb('switch_box', [0, 1, 2, 3], 4, n_wires_per_side)

    bitstream_json['switch_box'] = sb_json

    # Middle side switch box
    sb_json = generate_sb('switch_box_top', [0, 1, 2], 4, n_wires_per_side)
    bitstream_json['switch_box_top'] = sb_json

    sb_json = generate_sb('switch_box_left', [0, 1, 3], 4, n_wires_per_side)

    bitstream_json['switch_box_left'] = sb_json

    # Remove the duplicates here, merge with switch_box
    sb_json = generate_sb('switch_box_right', [0, 1, 2, 3], 4, n_wires_per_side)
    bitstream_json['switch_box_right'] = sb_json

    sb_json = generate_sb('switch_box_bottom', [0, 1, 2, 3], 4, n_wires_per_side)
    bitstream_json['switch_box_bottom'] = sb_json

    # Corner switch boxes
    sb_json = generate_sb('switch_box_top_left', [0, 1], 4, n_wires_per_side)
    bitstream_json['switch_box_top_left'] = sb_json

    sb_json = generate_sb('switch_box_top_right', [0, 1, 2], 4, n_wires_per_side)
    bitstream_json['switch_box_top_right'] = sb_json

    sb_json = generate_sb('switch_box_bottom_left', [0, 1, 3], 4, n_wires_per_side)
    bitstream_json['switch_box_bottom_left'] = sb_json

    # Remove the duplicates here, merge with switch_box
    sb_json = generate_sb('switch_box_bottom_right', [0, 1, 2, 3], 4, n_wires_per_side)
    bitstream_json['switch_box_bottom_right'] = sb_json

    # Generating PE tiles
    # Need to add flag for pe tiles that on the top and bottom?
    (pe_json, pe_top) = generate_pe_tile('pe_tile', 'switch_box', [0, 1, 2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile'] = pe_json
    topology_json['pe_tile'] = pe_top

    # Side PEs
    (pe_json, pe_top) = generate_pe_tile('pe_tile_left', 'switch_box_left', [0, 1, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_left'] = pe_json
    topology_json['pe_tile_left'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_right', 'switch_box_right', [1, 2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_right'] = pe_json
    topology_json['pe_tile_right'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_top', 'switch_box_top', [0, 1, 2], 4, n_wires_per_side)
    bitstream_json['pe_tile_top'] = pe_json
    topology_json['pe_tile_top'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_bottom', 'switch_box_bottom', [0, 2, 3], 4, n_wires_per_side, True)
    bitstream_json['pe_tile_bottom'] = pe_json
    topology_json['pe_tile_bottom'] = pe_top

    # Corner tiles
    (pe_json, pe_top) = generate_pe_tile('pe_tile_top_left', 'switch_box_top_left', [0, 1], 4, n_wires_per_side)
    bitstream_json['pe_tile_top_left'] = pe_json
    topology_json['pe_tile_top_left'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_top_right', 'switch_box_top_right', [1, 2], 4, n_wires_per_side)
    bitstream_json['pe_tile_top_right'] = pe_json
    topology_json['pe_tile_top_right'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_bottom_left', 'switch_box_bottom_left', [0, 3], 4, n_wires_per_side, True)
    bitstream_json['pe_tile_bottom_left'] = pe_json
    topology_json['pe_tile_bottom_left'] = pe_top

    (pe_json, pe_top) = generate_pe_tile('pe_tile_bottom_right', 'switch_box_bottom_right', [2, 3], 4, n_wires_per_side, True)
    bitstream_json['pe_tile_bottom_right'] = pe_json
    topology_json['pe_tile_bottom_right'] = pe_top

    top_mod = build_top_mod(grid_len, grid_len, grid_len, grid_len)

    name = 'top'
    top_file = open(name + '.v', 'w')
    top_file.write(build_verilog_string(top_mod))
    top_file.close()

    top_json = build_top_mod_bitstream_json(top_mod)
    top_topology_json = top_mod.topology_json() #build_top_mod_topology_json(top_mod)

    bitstream_json['top'] = top_json
    topology_json['top'] = top_topology_json

    # Manually written CLB
    clb_json = {'mod_name' : 'clb', 'components' : [{ 'config_map' : {'and' : 0, 'or' : 1, 'xor' : 2, 'reg' : 3}, "name" : "clb", "offset" : 0} ] }
    bitstream_json['clb'] = clb_json

    # Manually written connect box
    connect_box_json = {'mod_name' : 'connect_box', 'components' : [
        { 'config_map' : {'track0_in' : 0, 'track1_in' : 1, 'track2_in' : 2, 'track3_in' : 3, 'track4_in' : 4, 'track5_in' : 5, 'track6_in' : 6, 'track7_in' : 7}, "name" : "block_out", "offset" : 0},
    ] }
    bitstream_json['connect_box'] = connect_box_json

    # Write out json configuration data
    top_json_file = open(name + '.json', 'w')
    top_json_file.write(json.dumps(bitstream_json))
    top_json_file.close()

    # Write out topology file
    top_topology_file = open(name + '_topology.json', 'w')
    top_topology_file.write(json.dumps(topology_json))
    top_topology_file.close()

    print 'Done running generators'

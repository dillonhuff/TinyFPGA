from gen_switch_box import build_mod_str, generate_sb
from gen_pe_tile import generate_pe_tile
from gen_top import build_verilog_string, build_top_mod, build_top_mod_bitstream_json
import json

# I need to create a whole chip object that includes instantiations of io pads
# and pe tiles

# Note: The bitstream format does not need the full connection network info, so
# all of the connections in gen_top dont need to be included to generate the bitstream
# However, PnR needs all of those connections, so they will have to be included
# in the object eventually.

# Q: What is the smallest change I could make to get closer to that goal?

# Wrap up connections in gen_top into its own class
# Write connect box and CLB generators
# Merge generation calls so that files can be emitted at one time
# Emit json configuration data in one file at the end of generation
def run_generators():
    bitstream_json = {}

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
    pe_json = generate_pe_tile('pe_tile', 'switch_box', [0, 1, 2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile'] = pe_json

    # Side PEs
    pe_json = generate_pe_tile('pe_tile_left', 'switch_box_left', [0, 1, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_left'] = pe_json

    pe_json = generate_pe_tile('pe_tile_right', 'switch_box_right', [1, 2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_right'] = pe_json

    pe_json = generate_pe_tile('pe_tile_top', 'switch_box_top', [0, 1, 2], 4, n_wires_per_side)
    bitstream_json['pe_tile_top'] = pe_json

    pe_json = generate_pe_tile('pe_tile_bottom', 'switch_box_bottom', [0, 2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_bottom'] = pe_json

    # Corner tiles
    pe_json = generate_pe_tile('pe_tile_top_left', 'switch_box_top_left', [0, 1], 4, n_wires_per_side)
    bitstream_json['pe_tile_top_left'] = pe_json

    pe_json = generate_pe_tile('pe_tile_top_right', 'switch_box_top_right', [1, 2], 4, n_wires_per_side)
    bitstream_json['pe_tile_top_right'] = pe_json

    pe_json = generate_pe_tile('pe_tile_bottom_left', 'switch_box_bottom_left', [0, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_bottom_left'] = pe_json

    pe_json = generate_pe_tile('pe_tile_bottom_right', 'switch_box_bottom_right', [2, 3], 4, n_wires_per_side)
    bitstream_json['pe_tile_bottom_right'] = pe_json

    top_mod = build_top_mod(3, 3, 3, 3)

    name = 'top'
    top_file = open(name + '.v', 'w')
    top_file.write(build_verilog_string(top_mod))
    top_file.close()

    top_json = build_top_mod_bitstream_json(top_mod)

    bitstream_json['top'] = top_json
    top_json_file = open(name + '.json', 'w')
    top_json_file.write(json.dumps(bitstream_json))
    top_json_file.close()

    print 'Done running generators'

run_generators()

from gen_switch_box import build_mod_str, generate_sb
from gen_pe_tile import generate_pe_tile
from gen_top import build_verilog_string, build_top_mod

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
    n_wires_per_side = 4
    # Center switch box
    generate_sb('switch_box', [0, 1, 2, 3], 4, n_wires_per_side)

    # Middle side switch box
    generate_sb('switch_box_top', [0, 1, 2], 4, n_wires_per_side)
    generate_sb('switch_box_left', [0, 1, 3], 4, n_wires_per_side)
    # Remove the duplicates here, merge with switch_box
    generate_sb('switch_box_right', [0, 1, 2, 3], 4, n_wires_per_side)
    generate_sb('switch_box_bottom', [0, 1, 2, 3], 4, n_wires_per_side)

    # Corner switch boxes
    generate_sb('switch_box_top_left', [0, 1], 4, n_wires_per_side)
    generate_sb('switch_box_top_right', [0, 1, 2], 4, n_wires_per_side)
    generate_sb('switch_box_bottom_left', [0, 1, 3], 4, n_wires_per_side)
    # Remove the duplicates here, merge with switch_box
    generate_sb('switch_box_bottom_right', [0, 1, 2, 3], 4, n_wires_per_side)

    # Generating PE tiles
    generate_pe_tile('pe_tile', 'switch_box', [0, 1, 2, 3], 4, n_wires_per_side)

    # Side PEs
    generate_pe_tile('pe_tile_left', 'switch_box_left', [0, 1, 3], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_right', 'switch_box_right', [1, 2, 3], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_top', 'switch_box_top', [0, 1, 2], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_bottom', 'switch_box_bottom', [0, 2, 3], 4, n_wires_per_side)

    # Corner tiles
    generate_pe_tile('pe_tile_top_left', 'switch_box_top_left', [0, 1], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_top_right', 'switch_box_top_right', [1, 2], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_bottom_left', 'switch_box_bottom_left', [0, 3], 4, n_wires_per_side)
    generate_pe_tile('pe_tile_bottom_right', 'switch_box_bottom_right', [2, 3], 4, n_wires_per_side)

    name = 'top'
    pe_tile_file = open(name + '.v', 'w')
    top_mod = build_top_mod(3, 3, 3, 3)
    pe_tile_file.write(build_verilog_string(top_mod))
    pe_tile_file.close()
    
    print 'Done running generators'

run_generators()

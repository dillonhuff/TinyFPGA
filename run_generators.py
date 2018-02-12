from gen_switch_box import build_mod_str
from gen_pe_tile import build_pe_tile_str
from gen_top import build_top_str


def run_generators():
    # Center switch box
    sb_file = open('switch_box.v', 'w')
    sb_file.write(build_mod_str('switch_box', [0, 1, 2, 3], 4, 4))
    sb_file.close()

    # Middle side switch box
    sb_file = open('switch_box_top.v', 'w')
    sb_file.write(build_mod_str('switch_box_top', [0, 1, 2], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_left.v', 'w')
    sb_file.write(build_mod_str('switch_box_left', [0, 1, 3], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_right.v', 'w')
    sb_file.write(build_mod_str('switch_box_right', [0, 1, 2, 3], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_bottom.v', 'w')
    sb_file.write(build_mod_str('switch_box_bottom', [0, 1, 2, 3], 4, 4))
    sb_file.close()

    # Corner switch boxes
    sb_file = open('switch_box_top_left.v', 'w')
    sb_file.write(build_mod_str('switch_box_top_left', [0, 1], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_top_right.v', 'w')
    sb_file.write(build_mod_str('switch_box_top_right', [0, 1, 2], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_bottom_left.v', 'w')
    sb_file.write(build_mod_str('switch_box_bottom_left', [0, 1, 3], 4, 4))
    sb_file.close()

    sb_file = open('switch_box_bottom_right.v', 'w')
    sb_file.write(build_mod_str('switch_box_bottom_right', [0, 1, 2, 3], 4, 4))
    sb_file.close()

    pe_tile_file = open('pe_tile.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile', 'switch_box', [0, 1, 2, 3], 4, 4))
    pe_tile_file.close()

    # Side PEs
    pe_tile_file = open('pe_tile_left.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_left', 'switch_box_left', [0, 1, 3], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_right.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_right', 'switch_box_right', [1, 2, 3], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_top.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_top', 'switch_box_top', [0, 1, 2], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_bottom.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_bottom', 'switch_box_bottom', [0, 2, 3], 4, 4))
    pe_tile_file.close()

    # Corner tiles
    pe_tile_file = open('pe_tile_top_left.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_top_left', 'switch_box_top_left', [0, 1], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_top_right.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_top_right', 'switch_box_top_right', [1, 2], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_bottom_left.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_bottom_left', 'switch_box_bottom_left', [0, 3], 4, 4))
    pe_tile_file.close()

    pe_tile_file = open('pe_tile_bottom_right.v', 'w')
    pe_tile_file.write(build_pe_tile_str('pe_tile_bottom_right', 'switch_box_bottom_right', [2, 3], 4, 4))
    pe_tile_file.close()

    name = 'top'
    pe_tile_file = open(name + '.v', 'w')
    pe_tile_file.write(build_top_str(2, 2, 2, 2))
    pe_tile_file.close()
    
    print 'Done running generators'

run_generators()

import os

from testbench_utils import build_module
from run_generators import run_generators

run_generators(3)

build_module("switch_box")
build_module("switch_box_bottom")
build_module("pe_tile_bottom")
build_module("io1in_pad")
build_module("io1out_pad")
build_module("connect_box")
build_module("clb")
build_module("pe_tile")
build_module("top")

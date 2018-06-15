import sys
sys.path.insert(0, '../')

from gen_top import build_top_mod, build_verilog_string
from testbench_utils import os_cmd
from generator_utils import module_string
from verilog import VerilogModule, VerilogModuleInstance


grid_len = 3
top_mod = build_top_mod(grid_len, grid_len, grid_len, grid_len)
name = 'top'
top_file = open(name + '.v', 'w')
top_file.write(build_verilog_string(top_mod))
top_file.close()

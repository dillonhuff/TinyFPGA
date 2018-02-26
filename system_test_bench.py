import os
import json
from sets import Set

from run_generators import run_generators

def os_cmd(command_string):
    res = os.system(command_string)

    if (res != 0):
        print 'FAILED COMMAND: ', command_string
        assert(False)

def build_pnr():
    os_cmd("cd place_and_route; cmake .; make -j")

class ApplicationGraph:
    def __init__(self):
        self.nodes = Set([])

    def get_json(self):
        return {}

def build_reg_graph():
    app_g = ApplicationGraph()

    app_json = app_g.get_json()
    
    top_json_file = open('reg_app.json', 'w')
    top_json_file.write(json.dumps(app_json))
    top_json_file.close()
    
# Whole system test
# Create verilg for the 2 by 2 version of the FPGA
run_generators(2)

# Build the place and route tool and the bitstream writer
build_pnr()

# Build the application graph. In A separate C++ test bench? As python JSON and
# have the PnR tool load that as well?
build_reg_graph()

# Do place and route and then write the bitstream format to a file

# Run verilator on top module, then compile the verilated C++

# Run the verilated executable and output test result?

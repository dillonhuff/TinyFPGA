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

def run_place_and_route():
    app_file = 'reg_app.json'
    bitstream_format_file = 'top.json'
    topology_file = 'top_topology.json'
    bitstream_file = 'reg_bitstream.txt'

    os_cmd("./place_and_route/tiny-pnr " + app_file + " " + bitstream_format_file + " " + topology_file + " " + bitstream_file);

def verilate_example(mod_name, bistream_file):
    # Create main file

# --- Begin whole system test
# Create verilg for the 2 by 2 version of the FPGA
run_generators(2)

# Build the place and route tool and the bitstream writer
build_pnr()

# Build the application graph.
build_reg_graph()

# Do place and route and then write the bitstream format to a file
run_place_and_route()

# Run verilator on top module, then compile the verilated C++
verilate_example('top', 'reg_bitstream.txt')

# Run the verilated executable and output test result?

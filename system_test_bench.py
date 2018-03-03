import os
import json
from sets import Set

from run_generators import run_generators
from testbench_utils import build_module_with_main, os_cmd

def build_pnr():
    os_cmd("cd place_and_route; cmake .; make -j")

class ApplicationGraph:
    def __init__(self):
        self.nodes = Set([])

    def get_json(self):
        return {}

def run_place_and_route():
    app_file = 'reg_app.json'
    bitstream_format_file = 'top.json'
    topology_file = 'top_topology.json'
    bitstream_file = 'reg_bitstream.txt'

    os_cmd("./place_and_route/tiny-pnr " + app_file + " " +
           bitstream_format_file + " " + topology_file + " " + bitstream_file)

# Need to add a list of inputs along with the bitstream file
def verilate_example(mod_name,
                     bitstream_name,
                     output_file_name,
                     application_placement,
                     test_data):

    # Build data file
    num_cycles_to_run = 0
    for input_name in test_data:
        num_cycles_to_run = len(test_data[input_name])

    per_cycle_data = []
    for i in range(num_cycles_to_run):
        per_cycle_data.append([])

    input_names = ''
    for input_name in test_data:
        assert(num_cycles_to_run == len(test_data[input_name]))
        input_names += input_name + ','

        for i in range(0, len(test_data[input_name])):
            per_cycle_data[i].append(test_data[input_name][i])

    input_data_str = input_names + '\n'
    for row in per_cycle_data:
        
        for val in row:
            input_data_str += str(val) + ','

        input_data_str += '\n'

    data_in_file = open(mod_name + '_input_data.csv', 'w')
    data_in_file.write(input_data_str)
    data_in_file.close()
    
    # Note: The data file needs to map names in the application graph to
    # names in the placed design. Specifically input nodes in the application graph
    # to input ports in the design. 

    # Create main file
    main_name = 'auto_gen_tb_' + mod_name + '_' + bitstream_name + '_main.cpp'

    mainfile = open(main_name, 'w')

    vclass = 'V' + mod_name
    verilator_main_string = '#include <verilated.h>\n'
    verilator_main_string += '#include "' +  vclass + '.h"\n\n'
    verilator_main_string += 'int main(int argc, char **argv) {\n'

    vb = ''

    # Initialize the verilator object
    vb += '\tVerilated::commandArgs(argc, argv);\n'
    vb += '\t' + vclass + '* mod = new ' + vclass + ';\n'
    vb += '\tmod->clk = 0;\n'
    vb += '\tmod->eval();\n\n'

    vb += '\t// Run reset\n'
    vb += '\tmod->clk = 1;\n'
    vb += '\tmod->reset = 1;\n'
    vb += '\tmod->eval();\n'

    vb += '\tmod->clk = 0;\n'
    vb += '\tmod->eval();\n\n'
    
    # Load the chip configuration
    vb += '\t// Load the configuration\n'
    vb += '\tfor (int i = 0; i < 0; i++) {\n'
    vb += '\t}\n\n'
    
    # Run the design for a bunch of cycles, storing all output values in the design
    vb += '\t// Run the data for ' + str(num_cycles_to_run) + ' cycles,\n'
    vb += '\t// storing outputs along the way\n'
    vb += '\tfor (int i = 0; i < ' + str(2*num_cycles_to_run) + '; i++) {\n'
    vb += '\t}\n'

    verilator_main_string += vb
    verilator_main_string += '}'

    mainfile.write(verilator_main_string)
    mainfile.close()

    # Verilate example
    build_module_with_main(mod_name, main_name)

def simulate_application(app_g, num_cycles_to_run):
    return []

def compare_simulation_results(application_res, verilator_result_file):
    assert(True)

# --- Begin whole system test
# Create verilg for the 2 by 2 version of the FPGA. This includes generating
# json metadata for PnR and bitstream format conversion
run_generators(2)

# Build the place and route tool and the bitstream writer
build_pnr()

# Build the application graph and write it to json to be consumed by PnR
app_g = ApplicationGraph()

app_json = app_g.get_json()
top_json_file = open('reg_app.json', 'w')
top_json_file.write(json.dumps(app_json))
top_json_file.close()

# Create some data for each cycle
test_data = {'in0' : [0, 1, 0, 1, 1, 1, 1, 0, 0, 1]}

# Do place and route and then write the bitstream format to a file
run_place_and_route()

# Run verilator on top module, then compile the verilated C++, run the verilator code
# and save the simulation results to a file
num_cycles_to_run = 5
verilate_example('top', 'reg_bitstream', 'verilator_reg', {}, test_data)

# Run the pre-mapped application graph in simulation
res = simulate_application(app_g, num_cycles_to_run)

compare_simulation_results(res, 'verilator_reg')

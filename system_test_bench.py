import os
import json
from sets import Set

from run_generators import run_generators
from testbench_utils import build_module_with_main, os_cmd

def build_pnr():
    os_cmd("cd place_and_route; cmake .; make -j")

class ApplicationGraph:
    def __init__(self):
        self.next_node = 0
        self.next_edge = 0
        self.node_labels = {}
        self.out_edges = {}
        self.in_edges = {}
        self.edges = {}

    def get_json(self):
        app_json = {}
        app_json['out_edges'] = self.out_edges
        app_json['in_edges'] = self.in_edges
        app_json['edges'] = self.edges
        app_json['node_labels'] = self.node_labels
        return app_json

    def add_node(self, label):
        self.node_labels[self.next_node] = label

        self.out_edges[self.next_node] = []
        self.in_edges[self.next_node] = []

        node_val = self.next_node
        self.next_node += 1

        return node_val

    def add_edge(self, n0, n1, p0, p1):
        self.edges[self.next_edge] = (p0, p1)
        self.out_edges[n0].append(n1)
        self.in_edges[n1].append(n0)
        self.next_edge += 1

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
    #verilator_main_string += '#include <ifstream>\n'
    verilator_main_string += '#include <fstream>\n'
    verilator_main_string += '#include <iostream>\n'
    verilator_main_string += '#include <sstream>\n'
    verilator_main_string += '#include "' +  vclass + '.h"\n\n'
    verilator_main_string += 'using namespace std;\n\n'
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
    vb += '\tstd::ifstream input( "' + bitstream_name + '.txt" );\n'

    #vb += '\twhile (false) {\n'
    vb += '\tfor (std::string line; getline(input, line); ) {\n'
    vb += '\t\tstd::cout << line << std::endl;\n'

    vb += '\t\tstring addrStr = line.substr(0, 8);\n'

    vb += '\t\tunsigned int configAddr;\n'
    vb += '\t\tstd::stringstream ss;\n'
    vb += '\t\tss << std::hex << addrStr;\n'
    vb += '\t\tss >> configAddr;\n'

    vb += '\t\tstring dataStr = line.substr(9, 18);\n'

    vb += '\t\tunsigned int configData;\n'
    vb += '\t\tstd::stringstream ss2;\n'
    vb += '\t\tss2 << std::hex << dataStr;\n'
    vb += '\t\tss2 >> configData;\n'

    vb += '\t\tcout << "\taddrStr = " << addrStr << endl;\n'
    vb += '\t\tcout << "\tdataStr = " << dataStr << endl;\n'

    vb += '\t\tmod->config_addr = configAddr; // Insert config\n'
    vb += '\t\tmod->config_data = configData; // Insert data\n'
    vb += '\t\tmod->clk = 0;\n'
    vb += '\t\tmod->eval();\n'
    
    vb += '\t\tmod->clk = 1;\n'
    vb += '\t\tmod->eval();\n'
    
    vb += '\t}\n'
    vb += '\tinput.close();\n\n'

    vb += '\tstd::ofstream outFile("' + output_file_name + '.csv");\n'
    # Run the design for a bunch of cycles, storing all output values in the design
    vb += '\t// Run the data for ' + str(num_cycles_to_run) + ' cycles,\n'
    vb += '\t// storing outputs along the way\n'
    vb += '\tfor (int i = 0; i < ' + str(2*num_cycles_to_run) + '; i++) {\n'
    vb += '\t}\n'

    vb += '\toutFile.close();\n'

    verilator_main_string += vb
    verilator_main_string += '}'

    mainfile.write(verilator_main_string)
    mainfile.close()

    # Verilate example
    build_module_with_main(mod_name, main_name)

def simulate_application(app_g, num_cycles_to_run):
    results = []
    return results

def compare_simulation_results(application_res, verilator_result_file):
    # Read in result file table
    f = open(verilator_result_file, 'r')

    output_names = []
    data_start_line = 0
    found_in_names = False
    for line in f.read().split('\n'):
        print 'Line = ', line
        data_start_line += 1
        if len(line) == 0:
            continue
        else:
            names = f.split(',')
            assert(len(names) > 0)
            found_in_names = True
            for name in names:
                output_names.append(name)
            break

    assert(data_start_line > 0)
    assert(found_in_names)

    results = []

    return results

# --- Begin whole system test
# Create verilg for the 2 by 2 version of the FPGA. This includes generating
# json metadata for PnR and bitstream format conversion
run_generators(2)

# Build the place and route tool and the bitstream writer
build_pnr()

# Build the application graph and write it to json to be consumed by PnR
app_g = ApplicationGraph()
in_pad = app_g.add_node("io1in_pad")
out_pad = app_g.add_node("io1out_pad")
reg_n = app_g.add_node("reg")
app_g.add_edge(in_pad, reg_n, "out", "in0")
app_g.add_edge(reg_n, out_pad, "out", "in")


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

compare_simulation_results(res, 'verilator_reg.csv')

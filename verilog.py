from sets import Set

# Represent structural verilog + assignments

# Note: This is basically the yosys representation. No mapping back from wires
# to ports

# Note: Need to add input / output types on ports

# Note: tile to tile_id mappings are major piece of configurable state that is
# needed for this generator. After that we will need the mapping from tile names
# to tile type names. Also we are going to need tileIdStart, tileIdEnd,
# componentIdStart, componentIdEnd

# Q: What is the next small step toward a consistent, unified set of generators?
# Q: What am I trying to get to? A design where all json is generated uniformly
#    by each generate call and stored to a single json file. Verilog is generated
#    file by file (or all at once I guess would work too)

# Note: Should probably remove assigns and replace them with module instantiations
# This would make the verilog completely structural.
class VerilogModule():

    def __init__(self, mod_name, ports):
        self.mod_name = mod_name
        self.ports = ports

        self.metadata = {}
        self.instances = Set([])
        self.inst_to_wires = {}
        self.internal_wires = Set([])
        # TODO: Remove this feature
        self.assigns = Set([])
        self.wire_widths = {}

    def add_wire(self, wire_name, width=1):
        self.internal_wires.add(wire_name)
        self.wire_widths[wire_name] = width

    def add_instance(self, mod_name, inst_name):
        self.instances.add((mod_name, inst_name))
        self.inst_to_wires[inst_name] = []

    def add_assign(self, in_wire, driver_value):
        assert(in_wire in self.internal_wires)
        self.assigns.add((in_wire, driver_value))

    def add_instance_connection(self, inst_name_0, port_name_0, inst_name_1, port_name_1):
        conn = ((inst_name_0, port_name_0), (inst_name_1, port_name_1))

        w1 = conn[0][0] + '_' + conn[0][1]
        w2 = conn[1][0] + '_' + conn[1][1]
        wire_name = w1 + '_to_' + w2

        self.add_wire(wire_name)

        self.inst_to_wires[inst_name_0].append((port_name_0, wire_name))
        self.inst_to_wires[inst_name_1].append((port_name_1, wire_name))

    def add_port_connection(self, module_port_name, inst_name_0, inst_port_name):
        # assert(module_port_name in self.ports)

        self.inst_to_wires[inst_name_0].append((inst_port_name, module_port_name))

    # same as add port connection. Merge or add check for port to add_port_connection?
    def add_wire_connection(self, wire_name, inst_name_0, inst_port_name):
        assert(wire_name in self.internal_wires)
        self.inst_to_wires[inst_name_0].append((inst_port_name, wire_name))
        
    def body_string(self):
        body = ''

        body += '\t// Internal wires\n'
        for wire in self.internal_wires:
            width = self.wire_widths[wire]
            body += '\twire [' + str(width) + ' - 1 : 0] ' + wire + ';\n'
        body += '\t// End of internal wires\n'

        for inst in self.instances:
            mod_name = inst[0]
            inst_name = inst[1]
            body += '\t' + mod_name + ' ' + inst_name + '(\n'

            print 'inst = ', inst_name
            i = 0
            for port_wire_pair in self.inst_to_wires[inst_name]:
                body += '\t\t'
                body += '.' + port_wire_pair[0] + '(' + port_wire_pair[1] + ')'
                if i < len(self.inst_to_wires[inst_name]) - 1:
                    body += ','
                body += '\n'
                i += 1
            body += '\t);\n'

        body += '\t// Assignments \n'
        for assign in self.assigns:
            body += '\tassign ' + assign[0] + ' = ' + assign[1] + ';\n'
        
        return body


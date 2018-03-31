from sets import Set

# Represent structural verilog + assignments

class VerilogModuleInstance():

    def __init__(self, name, mod_name, parameters):
        self.name = name
        self.mod_name = mod_name
        self.parameters = parameters

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

        self.num_assigns = 0

        self.metadata = {}
        self.instances = {}
        self.inst_to_wires = {}

        self.internal_wires = Set([])
#        self.internal_regs = Set([])

        self.wire_widths = {}

        self.registered_wires = Set([])
        self.input_wires = Set([])
        self.output_wires = Set([])
        self.inout_wires = Set([])

        self.unique_int = 0

    # TODO: Single add function for wire, reg, port. Needs to accomodate both
    # port specific fields (inout, input, output) and reg / wire distinction
    def add_wire(self, wire_name, is_reg=False, is_port=False, port_type='', width=1):
        self.internal_wires.add(wire_name)
        self.wire_widths[wire_name] = width

        if is_reg:
            self.registered_wires.add(wire_name)

        if is_port:
            if (port_type == 'input'):
                self.input_wires.add(wire_name)
            elif (port_type == 'output'):
                self.output_wires.add(wire_name)
            elif (port_type == 'inout'):
                self.inout_wires.add(wire_name)
            else:
                assert(False)

        self.wire_widths[wire_name] = width

        return wire_name

    def add_reg(self, reg_name, width=1):
        self.add_wire(reg_name, True, False, '', width)
        
    def fresh_wire(self, width=1):
        i = self.unique_int
        self.add_wire('wire_' + str(i), False, False, '', width)
        self.unique_int += 1

        return 'wire_' + str(i)

    def fresh_reg(self, width=1):
        i = self.unique_int
        self.add_reg('reg_' + str(i), width)
        self.unique_int += 1

        return 'reg_' + str(i)
    
    def add_instance(self, mod_name, inst_name, parameters={}):
        self.instances[inst_name] = VerilogModuleInstance(inst_name, mod_name, parameters)
        self.inst_to_wires[inst_name] = []

    def add_assign(self, in_wire, driver_value):
        assert((in_wire in self.internal_wires))

        assign_name = 'assign_' + in_wire + '_' + str(self.num_assigns)
        const_name = assign_name + '_const'
        
        self.num_assigns += 1
        
        self.add_instance('assign_mod', assign_name, {'width' : self.wire_widths[in_wire]})
        self.add_instance('const_mod', const_name, {'value' : driver_value, 'width' : self.wire_widths[in_wire]})

        self.add_wire_connection(in_wire, assign_name, 'out')

        const_wire = self.fresh_wire(self.wire_widths[in_wire])

        self.add_wire_connection(const_wire, assign_name, 'in')
        self.add_wire_connection(const_wire, const_name, 'out')

    def add_instance_connection(self, inst_name_0, port_name_0, inst_name_1, port_name_1):
        conn = ((inst_name_0, port_name_0), (inst_name_1, port_name_1))

        w1 = conn[0][0] + '_' + conn[0][1]
        w2 = conn[1][0] + '_' + conn[1][1]
        wire_name = w1 + '_to_' + w2

        self.add_wire(wire_name)

        self.inst_to_wires[inst_name_0].append((port_name_0, wire_name))
        self.inst_to_wires[inst_name_1].append((port_name_1, wire_name))

    def add_port_connection(self, module_port_name, inst_name_0, inst_port_name):
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
            prefix = 'wire'
            if wire in self.registered_wires:
                prefix = 'reg'

            body += '\t' + prefix + ' [' + str(width) + ' - 1 : 0] ' + wire + ';\n'
        body += '\t// End of wire declarations\n\n'
        
        for inst_name in self.instances:
            mod_name = self.instances[inst_name].mod_name
            params = self.instances[inst_name].parameters

            body += '\t' + mod_name
            if (len(params) > 0):
                body += ' #('
                i = 0

                for param in params:
                    body += '.' + param + '(' + str(params[param]) + ')'
                    if (i != (len(params) - 1)):
                        body += ', '
                    i += 1

                body += ') '

            body += ' ' + inst_name + '(\n'

            print 'inst = ', inst_name
            i = 0
            for port_wire_pair in self.inst_to_wires[inst_name]:
                body += '\t\t'
                body += '.' + port_wire_pair[0] + '(' + port_wire_pair[1] + ')'
                if i < len(self.inst_to_wires[inst_name]) - 1:
                    body += ','
                body += '\n'
                i += 1
            body += '\t);\n\n'

        return body


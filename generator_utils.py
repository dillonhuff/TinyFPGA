def module_string(includes, name, ports, body):
    mod_str = ""
    for include_name in includes:
        mod_str += '`include \"' + include_name + '\"\n'

    mod_str += '\n\n'

    mod_str += 'module ' + name + '(\n'

    for i in range(0, len(ports)):
        mod_str += '\t' + ports[i]
        if (i != (len(ports) - 1)):
            mod_str += ',\n'

    mod_str += '\n\t);\n\n'

    mod_str += body

    mod_str += '\n\n'
    mod_str += 'endmodule'

    return mod_str


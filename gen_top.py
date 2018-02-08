from generator_utils import module_string

def build_top_str():
    includes = []
    ports = []
    body = ''
    return module_string(includes, 'top', ports, body)

pe_tile_file = open('top.v', 'w')
pe_tile_file.write(build_top_str())
pe_tile_file.close()
    

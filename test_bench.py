import os

from gen_switch_box import build_mod_str

def build_module(mod_name):
    v_command = "verilator -Wall -Wno-DECLFILENAME --cc " + mod_name + ".v --exe " + mod_name + "_main.cpp --top-module " + mod_name + " -CFLAGS -O3 -CFLAGS -march=native"
    verilate = os.system(v_command);

    if (verilate != 0):
        print 'ERROR: ' + mod_name + ' verilation failure',
        assert(False)

    m_command = "make -C obj_dir -j -f V" + mod_name + ".mk V" + mod_name

    make_cmd = os.system(m_command)

    if (make_cmd != 0):
        print 'ERROR: ' + mod_name + ' could not make verilated code',
        assert(False)

    run_cmd = os.system('./obj_dir/V' + mod_name)

    if (run_cmd != 0):
        print 'ERROR: ' + mod_name + ' tests failed'
        assert(False)

build_module("switch_box")
#build_module("io1_pad")
build_module("connect_box")
build_module("clb")
#build_module("pe_tile")

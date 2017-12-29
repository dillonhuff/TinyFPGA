all:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc clb.v --exe clb_main.cpp --top-module DesignTop -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f VDesignTop.mk VDesignTop
	./obj_dir/VDesignTop

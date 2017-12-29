all:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc clb.v --exe clb_main.cpp --top-module clb -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vclb.mk Vclb
	./obj_dir/Vclb

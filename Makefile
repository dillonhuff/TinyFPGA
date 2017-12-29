clb:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc clb.v --exe clb_main.cpp --top-module clb -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vclb.mk Vclb
	./obj_dir/Vclb

switch_box:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc switch_box.v --exe switch_box_main.cpp --top-module switch_box -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vswitch_box.mk Vswitch_box
	./obj_dir/Vswitch_box

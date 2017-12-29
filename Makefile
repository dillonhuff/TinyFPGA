all: clb switch_box connect_box pe_tile

clb:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc clb.v --exe clb_main.cpp --top-module clb -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vclb.mk Vclb
	./obj_dir/Vclb

switch_box:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc switch_box.v --exe switch_box_main.cpp --top-module switch_box -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vswitch_box.mk Vswitch_box
	./obj_dir/Vswitch_box

connect_box:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc connect_box.v --exe connect_box_main.cpp --top-module connect_box -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vconnect_box.mk Vconnect_box
	./obj_dir/Vconnect_box

pe_tile:
	verilator -O3 -x-assign fast -noassert -Wall -Wno-DECLFILENAME --cc pe_tile.v --exe pe_tile_main.cpp --top-module pe_tile -CFLAGS -O3 -CFLAGS -march=native
	make OPT_FAST="-O3" -C obj_dir -j -f Vpe_tile.mk Vpe_tile
	./obj_dir/Vpe_tile

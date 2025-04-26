+incdir+./src/common_cells/include
+incdir+./src/apb_pulp/include
+incdir+./src/axi/include
+incdir+./tb

./src/common_cells/src/cf_math_pkg.sv
./src/common_cells/src/addr_decode_dync.sv
./src/common_cells/src/addr_decode.sv
./src/common_cells/src/rr_arb_tree.sv
./src/common_cells/src/fall_through_register.sv
./src/common_cells/src/onehot_to_bin.sv
./src/common_cells/src/fifo_v3.sv
./src/common_cells/src/lzc.sv

./src/apb_pulp/src/apb_pkg.sv
./src/apb_pulp/src/apb_regs.sv
./src/apb_pulp/src/apb_intf.sv
./src/apb_pulp/src/apb_demux.sv

./src/axi/src/axi_pkg.sv
./src/axi/src/axi_intf.sv
./src/axi/src/axi_lite_to_apb.sv

./src/rtc/rtl/rtc_date.sv
./src/rtc/rtl/rtc_clock.sv
./src/rtc/rtl/rtc_top.sv
./src/rtc/rtl/bus_wrappers/rtc_apb.sv

./src/EF_TCC32/hdl/rtl/EF_TCC32.v
./src/EF_TCC32/hdl/rtl/bus_wrappers/EF_TCC32_apb_pulp.sv
./src/periphery.sv
./src/axil_periphery_wrap.sv
./tb/tb_env_pkg.sv
./tb/rtc_tb/axi_top/tb.sv


./tb/rtc_tb/axi_top/rtc_axi.cpp
./tb/rtc_tb/axi_top/main.cpp
#./tb/main.cpp
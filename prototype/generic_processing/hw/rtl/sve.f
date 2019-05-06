+incdir+./generic_fifos/rtl/verilog
+incdir+./buffers
+incdir+./state_machines
+incdir+../../../base/hw/rtl
+incdir+${FPGA_BBB_CCI_SRC}/BBB_cci_mpf/hw/rtl/cci-mpf-if/
// to avoid error
+incdir+/home/daniel/Desktop/transparent-acceleration/OPAE_Development/OPAE_Test/build_sim/rtl/
./cci_mpf_generic_afu.sv
./cci_mpf_app_conf.vh
./generic_fifos/bench/verilog/test_bench_top.v
./generic_fifos/rtl/verilog/lfsr.v
./generic_fifos/rtl/verilog/generic_fifo_dc.v
./generic_fifos/rtl/verilog/generic_fifo_lfsr.v
./generic_fifos/rtl/verilog/generic_fifo_dc_gray.v
./generic_fifos/rtl/verilog/generic_fifo_sc_b.v
./generic_fifos/rtl/verilog/generic_fifo_sc_a.v
../../../base/hw/rtl/cci_afu_with_mpf.sv
../../../base/hw/rtl/cci_mpf_app_conf_default.vh
../../../base/hw/rtl/csr_mgr.sv
../../../base/hw/rtl/csr_mgr.vh
${FPGA_BBB_CCI_SRC}/BBB_cci_mpf/hw/rtl/cci-mpf-if/cci_mpf_if.vh
// to avoid error
/home/daniel/Desktop/transparent-acceleration/OPAE_Development/OPAE_Test/build_sim/rtl/afu_json_info.vh



./buffers/buffer_512_to_64.sv
./buffers/buffer_64_to_512.sv

./state_machines/mpf_to_buffer_SM.sv
./state_machines/buffer_to_mpf_SM.sv
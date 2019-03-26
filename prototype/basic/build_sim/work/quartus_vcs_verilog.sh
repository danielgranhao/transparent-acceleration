mkdir -p ./verilog_libs/altera_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work altera_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/altera_primitives.v 
mkdir -p ./verilog_libs/lpm_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work lpm_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/220model.v 
mkdir -p ./verilog_libs/sgate_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work sgate_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/sgate.v 
mkdir -p ./verilog_libs/altera_mf_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work altera_mf_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/altera_mf.v 
mkdir -p ./verilog_libs/altera_lnsim_ver
vlogan -sverilog +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work altera_lnsim_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/altera_lnsim.sv 
mkdir -p ./verilog_libs/twentynm_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/twentynm_atoms.v 
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/synopsys/twentynm_atoms_ncrypt.v 
mkdir -p ./verilog_libs/twentynm_hssi_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_hssi_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/synopsys/twentynm_hssi_atoms_ncrypt.v 
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_hssi_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/twentynm_hssi_atoms.v 
mkdir -p ./verilog_libs/twentynm_hip_ver
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_hip_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/synopsys/twentynm_hip_atoms_ncrypt.v 
vlogan +v2k5 +incdir+/home/Daniel/altera_pro/16.0/quartus/eda/sim_lib -work twentynm_hip_ver /home/Daniel/altera_pro/16.0/quartus/eda/sim_lib/twentynm_hip_atoms.v 

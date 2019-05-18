
# (C) 2001-2019 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ----------------------------------------
# Auto-generated simulation script msim_setup.tcl
# ----------------------------------------
# This script can be used to simulate the following IP:
#     fft_ip_tb
# To create a top-level simulation script which compiles other
# IP, and manages other system issues, copy the following template
# and adapt it to your needs:
# 
# # Start of template
# # If the copied and modified template file is "mentor.do", run it as:
# #   vsim -c -do mentor.do
# #
# # Source the generated sim script
# source msim_setup.tcl
# # Compile eda/sim_lib contents first
# dev_com
# # Override the top-level name (so that elab is useful)
# set TOP_LEVEL_NAME top
# # Compile the standalone IP.
# com
# # Compile the user top-level
# vlog -sv ../../top.sv
# # Elaborate the design.
# elab
# # Run the simulation
# run -a
# # Report success to the shell
# exit -code 0
# # End of template
# ----------------------------------------
# If fft_ip_tb is one of several IP cores in your
# Quartus project, you can generate a simulation script
# suitable for inclusion in your top-level simulation
# script by running the following command line:
# 
# ip-setup-simulation <quartus project>
# 
# ip-setup-simulation will discover the Altera IP
# within the Quartus project, and generate a unified
# script which supports all the Altera IP within the design.
# ----------------------------------------
# ACDS 16.0 211 linux 2019.05.17.09:18:09

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "fft_ip_tb"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "/home/daniel/altera_pro/16.0/quartus/"
}

if ![info exists USER_DEFINED_COMPILE_OPTIONS] { 
  set USER_DEFINED_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_ELAB_OPTIONS] { 
  set USER_DEFINED_ELAB_OPTIONS ""
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp7.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp8.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp1.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp2.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp1.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp2.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp3.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp3.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp4.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp4.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp5.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp5.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp6.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp6.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp7.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twifp8.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp7.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twrfp8.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp1.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp2.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp3.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp4.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp5.hex ./
  file copy -force $QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq_twqfp6.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                   ./libraries/altera_ver/       
  vmap       altera_ver        ./libraries/altera_ver/       
  ensure_lib                   ./libraries/lpm_ver/          
  vmap       lpm_ver           ./libraries/lpm_ver/          
  ensure_lib                   ./libraries/sgate_ver/        
  vmap       sgate_ver         ./libraries/sgate_ver/        
  ensure_lib                   ./libraries/altera_mf_ver/    
  vmap       altera_mf_ver     ./libraries/altera_mf_ver/    
  ensure_lib                   ./libraries/altera_lnsim_ver/ 
  vmap       altera_lnsim_ver  ./libraries/altera_lnsim_ver/ 
  ensure_lib                   ./libraries/twentynm_ver/     
  vmap       twentynm_ver      ./libraries/twentynm_ver/     
  ensure_lib                   ./libraries/twentynm_hssi_ver/
  vmap       twentynm_hssi_ver ./libraries/twentynm_hssi_ver/
  ensure_lib                   ./libraries/twentynm_hip_ver/ 
  vmap       twentynm_hip_ver  ./libraries/twentynm_hip_ver/ 
  ensure_lib                   ./libraries/altera/           
  vmap       altera            ./libraries/altera/           
  ensure_lib                   ./libraries/lpm/              
  vmap       lpm               ./libraries/lpm/              
  ensure_lib                   ./libraries/sgate/            
  vmap       sgate             ./libraries/sgate/            
  ensure_lib                   ./libraries/altera_mf/        
  vmap       altera_mf         ./libraries/altera_mf/        
  ensure_lib                   ./libraries/altera_lnsim/     
  vmap       altera_lnsim      ./libraries/altera_lnsim/     
  ensure_lib                   ./libraries/twentynm/         
  vmap       twentynm          ./libraries/twentynm/         
  ensure_lib                   ./libraries/twentynm_hssi/    
  vmap       twentynm_hssi     ./libraries/twentynm_hssi/    
  ensure_lib                   ./libraries/twentynm_hip/     
  vmap       twentynm_hip      ./libraries/twentynm_hip/     
}
ensure_lib                                ./libraries/altera_common_sv_packages/     
vmap       altera_common_sv_packages      ./libraries/altera_common_sv_packages/     
ensure_lib                                ./libraries/altera_fft_ii_160/             
vmap       altera_fft_ii_160              ./libraries/altera_fft_ii_160/             
ensure_lib                                ./libraries/altera_conduit_bfm_160/        
vmap       altera_conduit_bfm_160         ./libraries/altera_conduit_bfm_160/        
ensure_lib                                ./libraries/altera_avalon_reset_source_160/
vmap       altera_avalon_reset_source_160 ./libraries/altera_avalon_reset_source_160/
ensure_lib                                ./libraries/altera_avalon_clock_source_160/
vmap       altera_avalon_clock_source_160 ./libraries/altera_avalon_clock_source_160/
ensure_lib                                ./libraries/fft_ip_10/                     
vmap       fft_ip_10                      ./libraries/fft_ip_10/                     

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                   -work altera_ver       
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                            -work lpm_ver          
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                               -work sgate_ver        
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                           -work altera_mf_ver    
    eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv"       -work altera_lnsim_ver 
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_atoms_for_vhdl.v"      -work twentynm_ver     
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v"        -work twentynm_ver     
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v"   -work twentynm_hssi_ver
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hssi_atoms_for_vhdl.v" -work twentynm_hssi_ver
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v"    -work twentynm_hip_ver 
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/twentynm_hip_atoms_for_vhdl.v"  -work twentynm_hip_ver 
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"             -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"         -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"            -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"         -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"      -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"                 -work altera           
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                           -work lpm              
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                          -work lpm              
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                        -work sgate            
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                             -work sgate            
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"              -work altera_mf        
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                         -work altera_mf        
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"           -work altera_lnsim     
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_atoms.vhd"                    -work twentynm         
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_components.vhd"               -work twentynm         
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hssi_components.vhd"          -work twentynm_hssi    
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hssi_atoms.vhd"               -work twentynm_hssi    
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hip_components.vhd"           -work twentynm_hip     
    eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hip_atoms.vhd"                -work twentynm_hip     
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_conduit_bfm_160/sim/verbosity_pkg.sv"                                                                  -work altera_common_sv_packages     
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/auk_dspip_text_pkg.vhd"                                                                 -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/auk_dspip_math_pkg.vhd"                                                                 -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/auk_dspip_lib_pkg.vhd"                                                                  -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/auk_dspip_avalon_streaming_block_sink.vhd"                                       -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/auk_dspip_avalon_streaming_block_source.vhd"                                     -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/auk_dspip_roundsat.vhd"                                                                 -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/auk_dspip_avalon_streaming_block_sink_fftfprvs.vhd"                              -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/auk_fft_pkg.vhd"                                                                 -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/altera_fft_dual_port_rom.vhd"                                                    -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/altera_fft_mult_add.vhd"                                                         -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/altera_fft_single_port_rom.vhd"                                                  -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/altera_fft_dual_port_ram.vhd"                                                    -work altera_fft_ii_160             
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/hyper_pipeline_interface.v"                                                      -work altera_fft_ii_160             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/counter_module.sv"                                  -L altera_common_sv_packages -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_fft4_hdfp.vhd"                                                         -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_dft4_hdfp.vhd"                                                         -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_twiddle_opt.vhd"                                                    -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_top.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_ram.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_stage.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_firststage.vhd"                                                     -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_del.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfpbdr_core.vhd"                                                           -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_stage.vhd"                                                          -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_rsft32.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_core.vhd"                                                              -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_snorm.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_fft4.vhd"                                                              -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_core.vhd"                                                           -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_twiddle.vhd"                                                           -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_hcc_cntsgn32.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_fft4.vhd"                                                           -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_mul_2727.vhd"                                                          -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_shift.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_top.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_snorm_mul.vhd"                                                         -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_hcc_sgnpstn.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_twiddle_opt.vhd"                                                       -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfpbdr_stage.vhd"                                                          -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_hcc_cntusgn32.vhd"                                                           -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfpbdr_laststage.vhd"                                                      -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_dft4.vhd"                                                              -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_laststage.vhd"                                                         -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_mul.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_add.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_lsft32.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfprvs_laststage.vhd"                                                      -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_rvs.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfpbdr_top.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_unorm.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_sub.vhd"                                                               -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_hcc_usgnpos.vhd"                                                             -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_rvsctl.vhd"                                                            -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfpbdr_firststage.vhd"                                                     -work altera_fft_ii_160             
  eval  vcom $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../altera_fft_ii_160/sim/mentor/apn_fftfp_cmplxmult.vhd"                                                         -work altera_fft_ii_160             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_fft_ii_160/sim/fft_ip_altera_fft_ii_160_jdm63cq.sv"                       -L altera_common_sv_packages -work altera_fft_ii_160             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_conduit_bfm_160/sim/altera_conduit_bfm_160_3fqkqha.sv"                    -L altera_common_sv_packages -work altera_conduit_bfm_160        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_conduit_bfm_160/sim/altera_conduit_bfm_160_oln7wka.sv"                    -L altera_common_sv_packages -work altera_conduit_bfm_160        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_avalon_reset_source_160/sim/altera_avalon_reset_source.sv"                -L altera_common_sv_packages -work altera_avalon_reset_source_160
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/../altera_avalon_clock_source_160/sim/altera_avalon_clock_source.sv"                -L altera_common_sv_packages -work altera_avalon_clock_source_160
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/../fft_ip_10/sim/fft_ip.v"                                                                                       -work fft_ip_10                     
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/fft_ip_tb.v"                                                                                                                                         
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L altera_fft_ii_160 -L altera_conduit_bfm_160 -L altera_avalon_reset_source_160 -L altera_avalon_clock_source_160 -L fft_ip_10 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L twentynm_ver -L twentynm_hssi_ver -L twentynm_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L twentynm -L twentynm_hssi -L twentynm_hip $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L altera_fft_ii_160 -L altera_conduit_bfm_160 -L altera_avalon_reset_source_160 -L altera_avalon_clock_source_160 -L fft_ip_10 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L twentynm_ver -L twentynm_hssi_ver -L twentynm_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L twentynm -L twentynm_hssi -L twentynm_hip $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo "                                 For most designs, this should be overridden"
  echo "                                 to enable the elab/elab_debug aliases."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
  echo
  echo "USER_DEFINED_COMPILE_OPTIONS  -- User-defined compile options, added to com/dev_com aliases."
  echo
  echo "USER_DEFINED_ELAB_OPTIONS     -- User-defined elaboration options, added to elab/elab_debug aliases."
}
file_copy
h

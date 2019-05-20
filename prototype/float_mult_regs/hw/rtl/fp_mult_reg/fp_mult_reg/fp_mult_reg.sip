set_global_assignment -entity "fp_mult_reg" -library "lib_fp_mult_reg" -name IP_TOOL_NAME "QsysPrimePro"
set_global_assignment -entity "fp_mult_reg" -library "lib_fp_mult_reg" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "fp_mult_reg" -library "lib_fp_mult_reg" -name IP_TOOL_ENV "QsysPrimePro"
set_global_assignment -library "lib_fp_mult_reg" -name SPD_FILE [file join $::quartus(sip_path) "fp_mult_reg.spd"]
set_global_assignment -library "lib_fp_mult_reg" -name MISC_FILE [file join $::quartus(sip_path) "../fp_mult_reg.qsys"]

set_global_assignment -library "lib_fp_mult_reg" -name MISC_FILE [file join $::quartus(sip_path) "sim/fp_mult_reg.v"]
set_global_assignment -library "lib_fp_mult_reg" -name MISC_FILE [file join $::quartus(sip_path) "altera_fpdsp_block_160/sim/fp_mult_reg_altera_fpdsp_block_160_e4wbm5a.sv"]

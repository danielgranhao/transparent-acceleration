set_global_assignment -entity "fp_mult" -library "lib_fp_mult" -name IP_TOOL_NAME "QsysPrimePro"
set_global_assignment -entity "fp_mult" -library "lib_fp_mult" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "fp_mult" -library "lib_fp_mult" -name IP_TOOL_ENV "QsysPrimePro"
set_global_assignment -library "lib_fp_mult" -name SPD_FILE [file join $::quartus(sip_path) "fp_mult.spd"]
set_global_assignment -library "lib_fp_mult" -name MISC_FILE [file join $::quartus(sip_path) "../fp_mult.qsys"]

set_global_assignment -library "lib_fp_mult" -name MISC_FILE [file join $::quartus(sip_path) "sim/fp_mult.v"]
set_global_assignment -library "lib_fp_mult" -name MISC_FILE [file join $::quartus(sip_path) "altera_fpdsp_block_160/sim/fp_mult_altera_fpdsp_block_160_4mzrtia.sv"]

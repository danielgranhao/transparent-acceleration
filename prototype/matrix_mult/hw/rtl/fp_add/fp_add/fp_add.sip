set_global_assignment -entity "fp_add" -library "lib_fp_add" -name IP_TOOL_NAME "QsysPrimePro"
set_global_assignment -entity "fp_add" -library "lib_fp_add" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "fp_add" -library "lib_fp_add" -name IP_TOOL_ENV "QsysPrimePro"
set_global_assignment -library "lib_fp_add" -name SPD_FILE [file join $::quartus(sip_path) "fp_add.spd"]
set_global_assignment -library "lib_fp_add" -name MISC_FILE [file join $::quartus(sip_path) "../fp_add.qsys"]

set_global_assignment -library "lib_fp_add" -name MISC_FILE [file join $::quartus(sip_path) "sim/fp_add.v"]
set_global_assignment -library "lib_fp_add" -name MISC_FILE [file join $::quartus(sip_path) "altera_fpdsp_block_160/sim/fp_add_altera_fpdsp_block_160_o5ob76q.sv"]

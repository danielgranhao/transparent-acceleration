set_global_assignment -entity "fp_mult_accumulate" -library "lib_fp_mult_accumulate" -name IP_TOOL_NAME "QsysPrimePro"
set_global_assignment -entity "fp_mult_accumulate" -library "lib_fp_mult_accumulate" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "fp_mult_accumulate" -library "lib_fp_mult_accumulate" -name IP_TOOL_ENV "QsysPrimePro"
set_global_assignment -library "lib_fp_mult_accumulate" -name SPD_FILE [file join $::quartus(sip_path) "fp_mult_accumulate.spd"]
set_global_assignment -library "lib_fp_mult_accumulate" -name MISC_FILE [file join $::quartus(sip_path) "../fp_mult_accumulate.qsys"]

set_global_assignment -library "lib_fp_mult_accumulate" -name MISC_FILE [file join $::quartus(sip_path) "sim/fp_mult_accumulate.v"]
set_global_assignment -library "lib_fp_mult_accumulate" -name MISC_FILE [file join $::quartus(sip_path) "altera_fpdsp_block_160/sim/fp_mult_accumulate_altera_fpdsp_block_160_pjjncdi.sv"]

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /buffer_64_to_512_tb/clk
add wave -noupdate /buffer_64_to_512_tb/rst
add wave -noupdate -radix decimal /buffer_64_to_512_tb/data_in
add wave -noupdate /buffer_64_to_512_tb/wr_enable
add wave -noupdate /buffer_64_to_512_tb/rd_enable
add wave -noupdate -radix hexadecimal /buffer_64_to_512_tb/data_out
add wave -noupdate -radix unsigned /buffer_64_to_512_tb/buffer_64_to_512/select_shifted
add wave -noupdate {/buffer_64_to_512_tb/buffer_64_to_512/genfifos[0]/generic_fifo_sc_a_inst/din}
add wave -noupdate {/buffer_64_to_512_tb/buffer_64_to_512/genfifos[0]/generic_fifo_sc_a_inst/we}
add wave -noupdate {/buffer_64_to_512_tb/buffer_64_to_512/genfifos[1]/generic_fifo_sc_a_inst/din}
add wave -noupdate {/buffer_64_to_512_tb/buffer_64_to_512/genfifos[1]/generic_fifo_sc_a_inst/we}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {613 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 296
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {495 ns} {716 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /buffer_512_to_64_tb/clk
add wave -noupdate /buffer_512_to_64_tb/rst
add wave -noupdate -radix decimal /buffer_512_to_64_tb/data_in
add wave -noupdate /buffer_512_to_64_tb/wr_enable
add wave -noupdate /buffer_512_to_64_tb/rd_enable
add wave -noupdate -radix decimal /buffer_512_to_64_tb/data_out
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[0]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[1]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[2]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[3]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[4]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[5]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[6]/generic_fifo_sc_a_inst/din}
add wave -noupdate -group {FIFOs Inputs} -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[7]/generic_fifo_sc_a_inst/din}
add wave -noupdate -radix unsigned /buffer_512_to_64_tb/buffer_512_to_64/select
add wave -noupdate {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[0]/generic_fifo_sc_a_inst/re}
add wave -noupdate -radix decimal {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[0]/generic_fifo_sc_a_inst/dout}
add wave -noupdate {/buffer_512_to_64_tb/buffer_512_to_64/genfifos[7]/generic_fifo_sc_a_inst/re}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {172 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 520
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
WaveRestoreZoom {49 ns} {189 ns}

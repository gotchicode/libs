quit -sim
vlib work

vcom -work work -quiet ../../clock_generator/src/clock_generator.vhd
vcom -work work -quiet ../../pn/src/pn_enc_dec.vhd
vcom -work work -quiet ../src/polyphase_interp.vhd

vcom -work work -quiet ../tb/polyphase_interp_tb.vhd


# Simulation launch
vsim -gui -t ps work.polyphase_interp_tb -novopt

add wave sim:/polyphase_interp_tb/*
add wave sim:/polyphase_interp_tb/poly_phase_block_inst/*

run 1 ms

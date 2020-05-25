quit -sim
vlib work

vcom -work work -quiet ../src/pn_enc_dec.vhd

vcom -work work -quiet ../tb/pn_enc_dec_tb.vhd


# Simulation launch
vsim -gui -t ps work.pn_enc_dec_tb -novopt

add wave -position insertpoint sim:/pn_enc_dec_tb/*
add wave -position insertpoint sim:/pn_enc_dec_tb/pn_enc_dec_inst/*

run 1 ms

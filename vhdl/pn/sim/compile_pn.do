quit -sim
vlib work

vcom -work work ../src/pn_enc_dec.vhd

vcom -work work +acc=rn ../tb/pn_enc_dec_tb.vhd


# Simulation launch
vsim -gui -t ns work.pn_enc_dec_tb

add wave -noupdate -divider {pn_enc_dec_tb}
add wave -position insertpoint sim:/pn_enc_dec_tb/*
add wave -noupdate -divider {pn_enc_dec_inst}
add wave -position insertpoint sim:/pn_enc_dec_tb/pn_enc_dec_inst/*

run 1 ms

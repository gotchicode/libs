quit -sim
vlib work

vcom -work work -quiet ../src/gain_mult.vhd

vcom -work work -quiet ../tb/gain_mult_tb.vhd


# Simulation launch
vsim -gui -t ps work.gain_mult_tb -novopt

add wave -position insertpoint sim:/gain_mult_tb/*
add wave -position insertpoint sim:/gain_mult_tb/gain_mult_inst/*

run 1 ms

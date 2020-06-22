quit -sim
vlib work

vcom -work work -quiet ../src/de0_top.vhd

vcom -work work -quiet ../tb/de0_top_tb.vhd


# Simulation launch
vsim -gui -t ps work.de0_top_tb -novopt

add wave -position insertpoint sim:/de0_top_tb/*
add wave -position insertpoint sim:/de0_top_tb/de0_top_inst/*

run 1 ms

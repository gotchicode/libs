quit -sim
vlib work

vcom -work work +acc=rn ../src/top.vhd

vcom -work work +acc=rn ../tb/top_tb.vhd


# Simulation launch
vsim -gui -t ps work.top_tb

add wave -position insertpoint sim:/top_tb/*
add wave -position insertpoint sim:/top_tb/top_inst/*

run 1 ms

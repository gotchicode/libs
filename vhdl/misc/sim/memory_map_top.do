quit -sim
vlib work

vcom -work work  ../src/memory_map_top.vhd

vcom -work work  ../tb/memory_map_top_tb.vhd


# Simulation launch
vsim -gui -t ps work.memory_map_top_tb

add wave -position insertpoint sim:/memory_map_top_tb/*
add wave -position insertpoint sim:/memory_map_top_tb/memory_map_top_inst/*

run 1 ms

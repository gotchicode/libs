quit -sim
vlib work

vcom -work work +acc=rn ../src/fir_with_tree.vhd

vcom -work work +acc=rn ../tb/fir_with_tree_tb.vhd

# Simulation launch
vsim -gui -t ps work.fir_with_tree_tb

add wave -position insertpoint sim:/fir_with_tree_tb/*
add wave -position insertpoint sim:/fir_with_tree_tb/fir_with_tree_inst/*

run 1 ms

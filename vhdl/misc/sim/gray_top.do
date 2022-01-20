quit -sim
vlib work

vcom -work work +acc=rn ../src/gray.vhd
vcom -work work +acc=rn ../src/gray_top.vhd

vcom -work work +acc=rn ../tb/gray_top_tb.vhd


# Simulation launch
vsim -gui -t ps work.gray_top_tb

add wave -position insertpoint sim:/gray_top_tb/*
add wave -position insertpoint sim:/gray_top_tb/gray_inst/*

run 60 us

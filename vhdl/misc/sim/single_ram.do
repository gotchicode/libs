quit -sim
vlib work

vcom -work work  ../src/single_ram.vhd

vcom -work work  ../tb/single_ram_tb.vhd


# Simulation launch
vsim -gui -t ps work.single_ram_tb

add wave -position insertpoint sim:/single_ram_tb/*
add wave -position insertpoint sim:/single_ram_tb/single_ram_inst/*

run 1 ms

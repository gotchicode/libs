quit -sim
vlib work

vcom -work work  ../../misc/src/single_ram.vhd
vcom -work work  ../src/gmsk_filter.vhd

vcom -work work  ../tb/gmsk_filter_tb.vhd


# Simulation launch
vsim -gui -t ps work.gmsk_filter_tb

add wave -position insertpoint sim:/gmsk_filter_tb/*
add wave -position insertpoint sim:/gmsk_filter_tb/gmsk_filter_inst/*

run 20 us

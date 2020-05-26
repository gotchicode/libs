quit -sim
vlib work

vcom -work work -quiet ../src/error_inject.vhd

vcom -work work -quiet ../tb/error_inject_tb.vhd


# Simulation launch
vsim -gui -t ps work.error_inject_tb -novopt

add wave -position insertpoint sim:/error_inject_tb/*
add wave -position insertpoint sim:/error_inject_tb/error_inject_inst/*

run 50 ms

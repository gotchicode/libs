quit -sim
vlib work

vcom -work work -quiet ./test.vhd

vcom -work work -quiet ./test_tb.vhd


# Simulation launch
vsim -gui -t ps work.test_tb -novopt

add wave -position insertpoint sim:/test_tb/*
add wave -position insertpoint sim:/test_tb/test_inst/*

run 1 ms

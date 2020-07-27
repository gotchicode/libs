quit -sim
vlib work

vcom -work work -quiet ../src/clock_generator.vhd

vcom -work work -quiet ../tb/clock_generator_tb.vhd


# Simulation launch
vsim -gui -t ps work.clock_generator_tb -novopt

add wave -position insertpoint sim:/clock_generator_tb/*
add wave -position insertpoint sim:/clock_generator_tb/clock_generator_inst/*

run 1 ms

quit -sim
vlib work

vcom -work work +acc=rn ../src/serial_unsigned_multiplier.vhd

vcom -work work +acc=rn ../tb/serial_unsigned_multiplier_tb.vhd


# Simulation launch
vsim -gui -t ps work.serial_unsigned_multiplier_tb

add wave -position insertpoint sim:/serial_unsigned_multiplier_tb/*
add wave -position insertpoint sim:/serial_unsigned_multiplier_tb/serial_unsigned_multiplier_inst/*

run 1 ms

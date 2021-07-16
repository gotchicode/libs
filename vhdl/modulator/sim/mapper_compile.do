quit -sim
vlib work

vcom -work work +acc=rn ../src/mapper.vhd

vcom -work work +acc=rn ../tb/mapper_tb.vhd


# Simulation launch
vsim -gui -t ps work.mapper_tb

add wave -position insertpoint sim:/mapper_tb/*
add wave -position insertpoint sim:/mapper_tb/mapper_inst/*

run 1 ms

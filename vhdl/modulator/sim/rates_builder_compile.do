quit -sim
vlib work

vcom -work work  +acc=rn ../src/rates_builder.vhd

vcom -work work  +acc=rn  ../tb/rates_builder_tb.vhd


# Simulation launch
vsim -gui -t ps work.rates_builder_tb

add wave -position insertpoint sim:/rates_builder_tb/*
add wave -position insertpoint sim:/rates_builder_tb/rates_builder_inst/*

run 100 us

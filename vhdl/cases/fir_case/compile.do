quit -sim
vlib work

vcom -work work -quiet ./fir_filter_numeric.vhd

vcom -work work -quiet ./fir_filter_numeric_tb.vhd


# Simulation launch
vsim -gui -t ps work.fir_filter_numeric_tb

add wave -position insertpoint sim:/fir_filter_numeric_tb/*
add wave -position insertpoint sim:/fir_filter_numeric_tb/fir_filter_numeric_inst/*

run 10 us

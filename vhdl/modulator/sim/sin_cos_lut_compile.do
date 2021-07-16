quit -sim
vlib work

vcom -work work +acc=rn ../src/sin_cos_lut.vhd

vcom -work work +acc=rn ../tb/sin_cos_lut_tb.vhd


# Simulation launch
vsim -gui -t ps work.sin_cos_lut_tb

add wave -position insertpoint sim:/sin_cos_lut_tb/*
add wave -position insertpoint sim:/sin_cos_lut_tb/sin_cos_lut_inst/*

run 5 ms

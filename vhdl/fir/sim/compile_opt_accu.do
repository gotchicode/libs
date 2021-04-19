quit -sim
vlib work

vcom -work work +acc=rn ../src/fir_with_opt_accu.vhd

vcom -work work +acc=rn ../tb/fir_with_opt_accu_tb.vhd

# Simulation launch
vsim -gui -t ps work.fir_with_opt_accu_tb

add wave -position insertpoint sim:/fir_with_opt_accu_tb/*
add wave -position insertpoint sim:/fir_with_opt_accu_tb/fir_with_opt_accu_inst/*

run 1 ms

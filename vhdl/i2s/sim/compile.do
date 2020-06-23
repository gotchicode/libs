quit -sim
vlib work

vcom -work work -quiet ../src/i2s_master_tx.vhd

vcom -work work -quiet ../tb/i2s_master_tx_tb.vhd


# Simulation launch
vsim -gui -t ps work.i2s_master_tx_tb -novopt

add wave -position insertpoint sim:/i2s_master_tx_tb/*
add wave -position insertpoint sim:/i2s_master_tx_tb/i2s_master_tx_inst/*

run 1 ms

quit -sim
vlib work

vcom -work work -quiet ../src/i2s_master_tx.vhd
vcom -work work -quiet ../src/i2s_master_rx.vhd

vcom -work work -quiet ../tb/i2s_master_rx_tb.vhd


# Simulation launch
vsim -gui -t ps work.i2s_master_rx_tb -novopt

add wave sim:/i2s_master_rx_tb/*
add wave sim:/i2s_master_rx_tb/i2s_master_tx_inst/*
add wave sim:/i2s_master_rx_tb/i2s_master_rx_inst/*


run 1 ms

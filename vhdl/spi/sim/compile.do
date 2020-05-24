quit -sim
vlib work

vcom -work work -quiet ../src/spi_master.vhd
vcom -work work -quiet ../src/spi_slave.vhd

vcom -work work -quiet ../tb/spi_master_tb.vhd


# Simulation launch
vsim -gui -t ps work.spi_master_tb -novopt

add wave -position insertpoint sim:/spi_master_tb/*
add wave -position insertpoint sim:/spi_master_tb/spi_master_inst/*
add wave -position insertpoint sim:/spi_master_tb/spi_slave_inst/*

run 2 ms

quit -sim
vlib work

vcom -work work +acc=rn ../src/axi_skid_buffer.vhd

vcom -work work +acc=rn ../tb/axi_skid_buffer_tb.vhd


# Simulation launch
vsim -gui -t ps work.axi_skid_buffer_tb

do wave.do

run 1 ms

quit -sim
vlib work

vcom -work work +acc=rn ../src/bus2ip_reg.vhd

vcom -work work +acc=rn ../tb/bus2ip_reg_tb.vhd


# Simulation launch
vsim -gui -t ps work.bus2ip_reg_tb

do wave.do

run 1 ms

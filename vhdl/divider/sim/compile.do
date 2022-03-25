quit -sim
vlib work

vcom -work work +acc=rn ../src/serial_divider.vhd

vcom -work work +acc=rn ../tb/serial_divider_tb.vhd


# Simulation launch
vsim -gui -t ps work.serial_divider_tb

do wave.do

run 1.6 us

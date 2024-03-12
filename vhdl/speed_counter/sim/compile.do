quit -sim
vlib work

vcom -work work +acc=rn ../src/speed_counter.vhd

vcom -work work +acc=rn ../tb/speed_counter_tb.vhd


# Simulation launch
vsim -gui -t ps work.speed_counter_tb

do wave.do

run 1 ms

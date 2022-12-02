quit -sim
vlib work

vcom -work work +acc=rn ../src/counter.vhd

vcom -work work +acc=rn ../tb/counter_tb.vhd


# Simulation launch
vsim -gui -t ps work.counter_tb

do wave.do

run 1 ms

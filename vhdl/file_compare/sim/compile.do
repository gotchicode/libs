quit -sim
vlib work

vcom -work work +acc=rn ../src/counter_dut.vhd

vcom -work work +acc=rn ../tb/counter_dut_tb.vhd


# Simulation launch
vsim -gui -t ps work.counter_dut_tb

do wave.do

run 1.4 us

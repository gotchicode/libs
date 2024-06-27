.main clear
quit -sim
vlib work

vlog -work work +acc=rn ../src/axis_rotate.sv
vlog -work work +acc=rn ../tb/axis_rotate_tb.sv

vsim -gui -t ps work.axis_rotate_tb

do wave.do

run 10 us

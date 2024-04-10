.main clear
quit -sim
vlib work

vlog -work work +acc=rn ../src/adder_tree.sv
vlog -work work +acc=rn ../tb/adder_tree_tb.sv

vsim -gui -t ps work.adder_tree_tb

do wave.do

run 1 us

quit -sim
vlib work

vcom -work work +acc=rn ../src/pipe_demo_stage_reg_ready.vhd

vcom -work work +acc=rn ../tb/pipe_demo_stage_reg_ready_tb.vhd


# Simulation launch
vsim -gui -t ps work.pipe_demo_stage_reg_ready_tb

do wave.do

run 1 ms

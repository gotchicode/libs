quit -sim
vlib work

vcom -work work +acc=rn ../src/phase_integrator.vhd

vcom -work work +acc=rn ../tb/phase_integrator_tb.vhd


# Simulation launch
vsim -gui -t ps work.phase_integrator_tb

add wave -position insertpoint sim:/phase_integrator_tb/*
add wave -position insertpoint sim:/phase_integrator_tb/phase_integrator_inst/*

run 1 ms

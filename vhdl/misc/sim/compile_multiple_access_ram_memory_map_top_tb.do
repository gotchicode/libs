quit -sim
vlib work

vcom -work work +acc=rn ../src/multiple_access_ram_memory_map_top.vhd

vcom -work work +acc=rn ../tb/multiple_access_ram_memory_map_top_tb.vhd


# Simulation launch
vsim -gui -t ps work.multiple_access_ram_memory_map_top_tb

do wave.do

run 1 ms

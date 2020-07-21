quit -sim
vlib work

vcom -work work -quiet ../../gain_mult/src/gain_mult.vhd
vcom -work work -quiet ../../i2s/src/i2s_master_tx.vhd
vcom -work work -quiet ../../pn/src/pn_enc_dec.vhd
vcom -work work -quiet ../src/sinus_rom.vhd
vcom -work work -quiet ../src/clk_rst_gen.vhd
vcom -work work -quiet ../src/de0_top.vhd
vcom -work work -quiet ../tb/pll_sim.vhd

vcom -work work -quiet ../tb/de0_top_tb.vhd


# Simulation launch
vsim -gui -t ps work.de0_top_tb -novopt

add wave -position insertpoint sim:/de0_top_tb/*
add wave -position insertpoint sim:/de0_top_tb/de0_top_inst/*
add wave sim:/de0_top_tb/de0_top_inst/clk_rst_gen_inst/*

run 1 ms


add wave -noupdate -divider {wavedrom_gen_tb}
add wave -position insertpoint sim:/wavedrom_gen_tb/*
add wave -noupdate -divider {wavedrom_gen}
add wave -position insertpoint sim:/wavedrom_gen_tb/wavedrom_gen_inst/*

config wave -signalnamewidth 1


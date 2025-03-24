add wave -noupdate -divider {reduced_msb_mult_tb}
add wave -position insertpoint sim:/reduced_msb_mult_tb/*
add wave -noupdate -divider {reduced_msb_mult_inst}
add wave -position insertpoint sim:/reduced_msb_mult_tb/reduced_msb_mult_inst/*
config wave -signalnamewidth 1
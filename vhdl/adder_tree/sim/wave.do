add wave -noupdate -divider {adder_tree_tb}
add wave -position insertpoint sim:/adder_tree_tb/*
add wave -noupdate -divider {adder_tree_inst}
add wave -position insertpoint sim:/adder_tree_tb/adder_tree_inst/*
config wave -signalnamewidth 1
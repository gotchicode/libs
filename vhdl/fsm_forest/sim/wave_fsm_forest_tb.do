
add wave -noupdate -divider {fsm_forest_tb}
add wave -position insertpoint sim:/fsm_forest_tb/*
add wave -noupdate -divider {fsm_forest_inst}
add wave -position insertpoint sim:/fsm_forest_tb/fsm_forest_inst/*
config wave -signalnamewidth 1


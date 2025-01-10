puts [pwd]
exec xvhdl "../../../wavedrom_gen/src/wavedrom_gen_pkg.vhd" "../../../wavedrom_gen/src/wavedrom_gen.vhd" "../../../wavedrom_gen/tb/wavedrom_gen_tb.vhd"
exec xelab wavedrom_gen_tb -debug typical --O0 --log xelab_log.txt 
exec xsim work.wavedrom_gen_tb -gui -tclbatch "add_to_waveform.tcl"
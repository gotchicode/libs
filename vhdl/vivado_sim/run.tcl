exec xvhdl "../../pn/src/pn_enc_dec.vhd" "../../pn/tb/pn_enc_dec_tb.vhd"
exec xelab pn_enc_dec_tb -debug typical --O0 --log xelab_log.txt 
exec xsim work.pn_enc_dec_tb -gui -tclbatch "add_to_waveform.tcl"
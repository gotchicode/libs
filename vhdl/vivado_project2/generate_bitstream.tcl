# Launch the bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs 4

#Wait vivado to finish
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
   error "ERROR: impl_1 failed"
}
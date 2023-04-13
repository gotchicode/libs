# Launch the synthesis
launch_runs synth_1 -jobs 4

#Wait vivado to finish
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
   error "ERROR: synth_1 failed"
}


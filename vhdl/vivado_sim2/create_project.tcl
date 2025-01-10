# Project name
set project_name "my_project"

# Working directory
set work_dir ""

# Create project
create_project $project_name $work_dir -part xc7a12tcpg238-3

# Add source files
add_files -norecurse {../../wavedrom_gen/src/wavedrom_gen_pkg.vhd}
add_files -norecurse {../../wavedrom_gen/src/wavedrom_gen.vhd}
add_files -norecurse {../../wavedrom_gen/tb/wavedrom_gen_tb.vhd}

# Specify libraries
set_property library work [get_files  ../../wavedrom_gen/src/wavedrom_gen_pkg.vhd]
set_property library work [get_files  ../../wavedrom_gen/src/wavedrom_gen.vhd]
set_property library work [get_files  ../../wavedrom_gen/tb/wavedrom_gen_tb.vhd]

# Specify the top file
set_property top wavedrom_gen [current_fileset]

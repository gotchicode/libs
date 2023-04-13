# Project name
set project_name "my_project"

# Working directory
set work_dir ""

# Create project
create_project $project_name $work_dir -part xc7a12tcpg238-3

# Add source files
add_files -norecurse {../../misc/src/gray.vhd}
add_files -norecurse {../../misc/src/gray_top.vhd}

# Add constraints
add_files -norecurse $work_dir../constraints/constraints.xdc

# Specify libraries
set_property library work [get_files  ../../misc/src/gray.vhd]
set_property library work [get_files  ../../misc/src/gray_top.vhd]

# Specify the top file
set_property top gray_top [current_fileset]

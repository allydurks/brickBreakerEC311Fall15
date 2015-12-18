
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name BreakTheBricks -dir "X:/Desktop/EC311 Labs/BreakTheBricks/planAhead_run_2" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "X:/Desktop/EC311 Labs/brickBreaker from allison/brickBreaker/vga_display.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../brickBreaker from allison/brickBreaker/vga_controller_640_60.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../brickBreaker from allison/brickBreaker/vga_display_movement.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top vga_display $srcset
add_files [list {X:/Desktop/EC311 Labs/brickBreaker from allison/brickBreaker/vga_display.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3

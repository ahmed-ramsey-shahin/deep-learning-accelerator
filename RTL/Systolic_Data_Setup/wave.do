onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Systolic_Data_Setup_tb/CLK
add wave -noupdate -radix unsigned /Systolic_Data_Setup_tb/ASYNC_RST
add wave -noupdate -radix unsigned /Systolic_Data_Setup_tb/EN
add wave -noupdate -radix unsigned -childformat {{{/Systolic_Data_Setup_tb/Inputs[0]} -radix unsigned} {{/Systolic_Data_Setup_tb/Inputs[1]} -radix unsigned} {{/Systolic_Data_Setup_tb/Inputs[2]} -radix unsigned} {{/Systolic_Data_Setup_tb/Inputs[3]} -radix unsigned} {{/Systolic_Data_Setup_tb/Inputs[4]} -radix unsigned}} -expand -subitemconfig {{/Systolic_Data_Setup_tb/Inputs[0]} {-radix unsigned} {/Systolic_Data_Setup_tb/Inputs[1]} {-radix unsigned} {/Systolic_Data_Setup_tb/Inputs[2]} {-radix unsigned} {/Systolic_Data_Setup_tb/Inputs[3]} {-radix unsigned} {/Systolic_Data_Setup_tb/Inputs[4]} {-radix unsigned}} /Systolic_Data_Setup_tb/Inputs
add wave -noupdate -radix unsigned -childformat {{{/Systolic_Data_Setup_tb/Outputs[0]} -radix unsigned -childformat {{{/Systolic_Data_Setup_tb/Outputs[0][7]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][6]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][5]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][4]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][3]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][2]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][1]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][0]} -radix unsigned}}} {{/Systolic_Data_Setup_tb/Outputs[1]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[2]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[3]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[4]} -radix unsigned}} -expand -subitemconfig {{/Systolic_Data_Setup_tb/Outputs[0]} {-height 15 -radix unsigned -childformat {{{/Systolic_Data_Setup_tb/Outputs[0][7]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][6]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][5]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][4]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][3]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][2]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][1]} -radix unsigned} {{/Systolic_Data_Setup_tb/Outputs[0][0]} -radix unsigned}}} {/Systolic_Data_Setup_tb/Outputs[0][7]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][6]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][5]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][4]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][3]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][2]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][1]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[0][0]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[1]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[2]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[3]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/Outputs[4]} {-height 15 -radix unsigned}} /Systolic_Data_Setup_tb/Outputs
add wave -noupdate -radix unsigned -childformat {{{/Systolic_Data_Setup_tb/DUT/delays[0]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[1]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[2]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[3]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[4]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[5]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[6]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[7]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[8]} -radix unsigned} {{/Systolic_Data_Setup_tb/DUT/delays[9]} -radix unsigned}} -subitemconfig {{/Systolic_Data_Setup_tb/DUT/delays[0]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[1]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[2]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[3]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[4]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[5]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[6]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[7]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[8]} {-height 15 -radix unsigned} {/Systolic_Data_Setup_tb/DUT/delays[9]} {-height 15 -radix unsigned}} /Systolic_Data_Setup_tb/DUT/delays
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11541 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {120750 ps}

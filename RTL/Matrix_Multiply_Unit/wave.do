onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/CLK
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/EN
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/LOAD
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/Inputs
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/Weights
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/Result
add wave -noupdate -radix unsigned -childformat {{{/Matrix_Multiply_Unit_tb/ActualResult[0]} -radix unsigned} {{/Matrix_Multiply_Unit_tb/ActualResult[1]} -radix unsigned} {{/Matrix_Multiply_Unit_tb/ActualResult[2]} -radix unsigned}} -expand -subitemconfig {{/Matrix_Multiply_Unit_tb/ActualResult[0]} {-height 15 -radix unsigned} {/Matrix_Multiply_Unit_tb/ActualResult[1]} {-height 15 -radix unsigned} {/Matrix_Multiply_Unit_tb/ActualResult[2]} {-height 15 -radix unsigned}} /Matrix_Multiply_Unit_tb/ActualResult
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25930 ps} 0}
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
WaveRestoreZoom {0 ps} {147 ns}

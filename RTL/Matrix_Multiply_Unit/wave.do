onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/CLK
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/EN
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/ASYNC_RST
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/SYNC_RST
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/Inputs
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/Weights
add wave -noupdate -radix unsigned /Matrix_Multiply_Unit_tb/PsumOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42804 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {131250 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Processing_Element_tb/CLK
add wave -noupdate /Processing_Element_tb/RST
add wave -noupdate /Processing_Element_tb/Load
add wave -noupdate -radix decimal /Processing_Element_tb/Input
add wave -noupdate -radix decimal /Processing_Element_tb/Weight
add wave -noupdate -radix decimal /Processing_Element_tb/PsumIn
add wave -noupdate -radix decimal /Processing_Element_tb/ToDown
add wave -noupdate -radix decimal /Processing_Element_tb/PsumOut
add wave -noupdate -radix decimal /Processing_Element_tb/ToRight
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31900 ps} 0}
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
WaveRestoreZoom {0 ps} {52500 ps}

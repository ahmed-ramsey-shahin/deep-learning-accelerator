onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/CLK
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/ASYNC_RST
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/SYNC_RST
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/EN
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/InputVectorSelector
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/Inputs
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/OutputVectorSelector
add wave -noupdate -radix unsigned /Accumulators_tb/DUT/Result
add wave -noupdate -radix unsigned -childformat {{{/Accumulators_tb/DUT/Vectors[0]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[1]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[2]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[3]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[4]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[5]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[6]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[7]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[8]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[9]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[10]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[11]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[12]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[13]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[14]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[15]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[16]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[17]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[18]} -radix unsigned} {{/Accumulators_tb/DUT/Vectors[19]} -radix unsigned}} -subitemconfig {{/Accumulators_tb/DUT/Vectors[0]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[1]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[2]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[3]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[4]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[5]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[6]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[7]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[8]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[9]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[10]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[11]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[12]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[13]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[14]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[15]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[16]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[17]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[18]} {-height 15 -radix unsigned} {/Accumulators_tb/DUT/Vectors[19]} {-height 15 -radix unsigned}} /Accumulators_tb/DUT/Vectors
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9785 ps} 0}
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
WaveRestoreZoom {0 ps} {42 ns}

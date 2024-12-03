vlib work
vlog HA.v FA.v wallace_tree_multiplier_8x8.v wallace_tree_multiplier_8x8_tb.v
vsim -voptargs=+acc work.wallace_tree_multiplier_8x8_tb
add wave a
add wave b
add wave product
add wave expected_product
config wave -signalnamewidth 1
run -all
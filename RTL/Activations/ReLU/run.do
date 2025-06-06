vlib work
vlog ReLU.v ReLU_tb.v
vsim -voptargs=+acc work.ReLU_tb
add wave *
config wave -signalnamewidth 1
run -all
#quit -sim
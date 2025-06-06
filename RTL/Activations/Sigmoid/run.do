vlib work
vlog Sigmoid.v Sigmoid_tb.sv
vsim -voptargs=+acc work.Sigmoid_tb
add wave *
config wave -signalnamewidth 1
run -all
#quit -sim
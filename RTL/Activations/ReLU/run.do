vlib work
vlog ReLU.v ReLU_tb.v
vsim -voptargs=+acc work.ReLU_tb
add wave *
radix bin
names in
names out
run -all
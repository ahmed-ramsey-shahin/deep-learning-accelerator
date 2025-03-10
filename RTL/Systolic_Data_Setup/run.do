vlib work
vlog *.sv
vsim -voptargs=+acc work.Systolic_Data_Setup_tb
do wave.do
run -all

vlib work
vlog *.v
vsim -voptargs=+acc work.Carry_Save_Multiplier_tb
do wave.do
run -all

vlib work
vlog *.v
vlog ../Multipliers/Carry_Save_Multiplier/*.v
vsim -voptargs=+acc work.Processing_Element_tb
do wave.do
run -all

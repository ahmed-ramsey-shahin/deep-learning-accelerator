vlib work
vlog *.v
vlog ../Multipliers/Carry_Save_Multiplier/*.v
vlog ../Processing_Element/*.v
vsim -voptargs=+acc work.Matrix_Multiply_Unit_tb
#do wave.do
run -all

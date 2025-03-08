
vlib work
vlog *.sv
vlog ../Matrix_Multiply_Unit/*.sv
vlog ../Multipliers/Carry_Save_Multiplier/*.v
vlog ../Processing_Element/*.v
vsim -voptargs=+acc work.Accumulators_tb
do wave.do
run -all

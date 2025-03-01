vlib work
vlog *.sv
vlog ../Multipliers/Carry_Save_Multiplier/*.v
vlog ../Processing_Element/*.v
vlog ../Matrix_Multiply_Unit/*.sv
vsim -voptargs=+acc work.Accumulator_tb
#do wave.do
run -all

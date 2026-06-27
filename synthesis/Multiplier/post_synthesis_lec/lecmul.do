read library -Both -Replace -sensitive -Statetable -Liberty /home/installs/digital/90nm/dig/lib/slow.lib -nooptimize
read design /home/workshop03/simulation/synthesis/day4assign/post_synthesis_lec/mul32pipe.v -Verilog -Golden -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply
read design /home/workshop03/simulation/synthesis/day4assign/post_synthesis_lec/multiplier_netlist.v -Verilog -Revised -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply
set system mode lec
verify
report verify
save session ./lec_session -replace

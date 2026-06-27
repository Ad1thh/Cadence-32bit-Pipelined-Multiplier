// 1. Read the Golden/Reference Technology Library
read library -Both -Replace -sensitive -Statetable -Liberty /home/installs/digital/90nm/dig/lib/slow.lib -nooptimize

// 2. Read the Golden Design
read design /home/workshop03/floorplanning/lec_postroute/multiplier_netlist.v -Verilog -Golden -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply

// 3. Read the Revised/Post-Route Design
read design /home/workshop03/floorplanning/lec_postroute/mul32_pipeline_netlist_Implem.v -Verilog -Revised -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply

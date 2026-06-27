read_libs /home/installs/digital/90nm/dig/lib/slow.lib
read_hdl mul32pipe.v
elaborate
read_sdc /home/workshop03/simulation/synthesis/day4assign/constraint.sdc
syn_generic
syn_map
syn_opt
gui_show
write_hdl > multiplier_netlist.v
write_sdc > output_constraints.sdc
report_area > multiplier_area.rpt
report_power > multiplier_power.rpt
report_timing > multiplier_timing.rpt
report_gates > multiplier_gates.rpt

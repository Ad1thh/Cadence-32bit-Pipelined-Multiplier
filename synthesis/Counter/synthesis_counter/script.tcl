read_libs /home/installs/digital/90nm/dig/lib/slow.lib
read_hdl counter.v
elaborate
read_sdc constraints.sdc
syn_generic
syn_map
syn_opt
gui_show
write_hdl > counter_netlist.v
write_sdc > output_constraints.sdc
report_area > counter_area.rpt
report_power > counter_power.rpt
report_timing > counter_timing.rpt
report_gates > counter_gates.rpt

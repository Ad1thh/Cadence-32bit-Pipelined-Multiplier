# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Thu Jun 04 15:29:59 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design counter

create_clock -name "clk" -period 1.0 -waveform {0.0 0.5} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports reset]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports up_down]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports {count[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports {count[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports {count[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.4 [get_ports {count[0]}]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.01 [get_ports clk]
set_clock_uncertainty -hold 0.01 [get_ports clk]

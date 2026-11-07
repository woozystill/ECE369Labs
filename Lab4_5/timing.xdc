create_clock -period 10.000 -name Clk -waveform {0.000 5.000} [get_ports Clk]

create_generated_clock -name SlowClk -source [get_ports Clk] -divide_by 100000002 [get_pins {m1/ClkOut_reg/Q}]

# Basys 3 - 100 MHz Clock
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]

# Reset - Center Button
set_property PACKAGE_PIN U18 [get_ports Reset]
set_property IOSTANDARD LVCMOS33 [get_ports Reset]

# Seven-Segment Display (gfedcba)
set_property PACKAGE_PIN W7 [get_ports {out7[0]}]
set_property PACKAGE_PIN W6 [get_ports {out7[1]}]
set_property PACKAGE_PIN U8 [get_ports {out7[2]}]
set_property PACKAGE_PIN V8 [get_ports {out7[3]}]
set_property PACKAGE_PIN U5 [get_ports {out7[4]}]
set_property PACKAGE_PIN V5 [get_ports {out7[5]}]
set_property PACKAGE_PIN U7 [get_ports {out7[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {out7[*]}]

# Four Digit Enables
set_property PACKAGE_PIN U2 [get_ports {en_out[0]}]
set_property PACKAGE_PIN U4 [get_ports {en_out[1]}]
set_property PACKAGE_PIN V4 [get_ports {en_out[2]}]
set_property PACKAGE_PIN W4 [get_ports {en_out[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {en_out[*]}]

# Decimal Points
set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

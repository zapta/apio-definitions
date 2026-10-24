
#-- Alinx AX7035B board

#-- System clock (50 MHz)
set_property -dict { PACKAGE_PIN Y18    IOSTANDARD LVCMOS33 } [get_ports {CLK}]

#-- LEDs (active low)
set_property -dict { PACKAGE_PIN F19    IOSTANDARD LVCMOS33 } [get_ports {LEDS[0]}]
set_property -dict { PACKAGE_PIN E21    IOSTANDARD LVCMOS33 } [get_ports {LEDS[1]}]
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports {LEDS[2]}]
set_property -dict { PACKAGE_PIN C20    IOSTANDARD LVCMOS33 } [get_ports {LEDS[3]}]

#-- Pin source: AX7035B user manual


#-- Placa MicroPhase A7-Lite

#-- Reloj del sistema (50 MHz)
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports {sys_clk}]

#-- LEDs (activos a nivel bajo) (active low)
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]

#-- Fuente de los pines: MicroPhase A7-Lite Reference Manual + esquematico R1.1

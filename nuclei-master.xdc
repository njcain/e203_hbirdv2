set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports CLK50MHZ]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IOBUF_jtag_TCK/O]

#####                rst define           #####
set_property PACKAGE_PIN C4 [get_ports fpga_rst]
set_property PACKAGE_PIN G11 [get_ports mcu_rst]

#####                spi0 define               #####
set_property PACKAGE_PIN R16 [get_ports qspi0_sck]
set_property PACKAGE_PIN P16 [get_ports qspi0_cs]
set_property PACKAGE_PIN J5 [get_ports {qspi0_dq[3]}]
set_property PACKAGE_PIN H4 [get_ports {qspi0_dq[2]}]
set_property PACKAGE_PIN G4 [get_ports {qspi0_dq[1]}]
set_property PACKAGE_PIN H5 [get_ports {qspi0_dq[0]}]

#####               MCU JTAG define           #####
set_property PACKAGE_PIN M15 [get_ports mcu_TCK]
set_property PACKAGE_PIN L15 [get_ports mcu_TDI]
set_property PACKAGE_PIN N16 [get_ports mcu_TDO]
set_property PACKAGE_PIN M16 [get_ports mcu_TMS]
set_property KEEPER true [get_ports mcu_TMS]

#####                PMU define               #####
set_property PACKAGE_PIN P15 [get_ports mcu_wakeup]
set_property PACKAGE_PIN K13 [get_ports pmu_padrst]
set_property PACKAGE_PIN H11 [get_ports pmu_paden]

#####                gpioA define              #####
set_property PACKAGE_PIN P6 [get_ports {gpioA[31]}]
set_property PACKAGE_PIN M6 [get_ports {gpioA[30]}]
set_property PACKAGE_PIN R5 [get_ports {gpioA[29]}]
set_property PACKAGE_PIN N6 [get_ports {gpioA[28]}]
set_property PACKAGE_PIN T5 [get_ports {gpioA[27]}]
set_property PACKAGE_PIN P8 [get_ports {gpioA[26]}]
set_property PACKAGE_PIN R6 [get_ports {gpioA[25]}]
set_property PACKAGE_PIN R8 [get_ports {gpioA[24]}]
set_property PACKAGE_PIN R7 [get_ports {gpioA[23]}]
set_property PACKAGE_PIN N9 [get_ports {gpioA[22]}]
set_property PACKAGE_PIN T7 [get_ports {gpioA[21]}]
set_property PACKAGE_PIN P9 [get_ports {gpioA[20]}]
set_property PACKAGE_PIN T8 [get_ports {gpioA[19]}]
set_property PACKAGE_PIN P10 [get_ports {gpioA[18]}]
set_property PACKAGE_PIN T9 [get_ports {gpioA[17]}]
set_property PACKAGE_PIN P11 [get_ports {gpioA[16]}]
set_property PACKAGE_PIN T10 [get_ports {gpioA[15]}]
set_property PACKAGE_PIN R12 [get_ports {gpioA[14]}]
set_property PACKAGE_PIN R10 [get_ports {gpioA[13]}]
set_property PACKAGE_PIN T12 [get_ports {gpioA[12]}]
set_property PACKAGE_PIN R13 [get_ports {gpioA[11]}]
set_property PACKAGE_PIN N11 [get_ports {gpioA[10]}]
set_property PACKAGE_PIN T13 [get_ports {gpioA[9]}]
set_property PACKAGE_PIN N12 [get_ports {gpioA[8]}]
set_property PACKAGE_PIN N14 [get_ports {gpioA[7]}]
set_property PACKAGE_PIN T14 [get_ports {gpioA[6]}]
set_property PACKAGE_PIN P14 [get_ports {gpioA[5]}]
set_property PACKAGE_PIN T15 [get_ports {gpioA[4]}]
set_property PACKAGE_PIN M14 [get_ports {gpioA[3]}]
set_property PACKAGE_PIN L13 [get_ports {gpioA[2]}]
set_property PACKAGE_PIN L14 [get_ports {gpioA[1]}]
set_property PACKAGE_PIN K12 [get_ports {gpioA[0]}]

#####            clock & rst define           #####

set_property IOSTANDARD LVCMOS33 [get_ports fpga_rst]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_rst]

#####                spi0 define               #####
set_property IOSTANDARD LVCMOS33 [get_ports qspi0_cs]
set_property IOSTANDARD LVCMOS33 [get_ports qspi0_sck]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi0_dq[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi0_dq[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi0_dq[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi0_dq[0]}]


#####               MCU JTAG define           #####
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDO]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TCK]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDI]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TMS]

#####                PMU define               #####
set_property IOSTANDARD LVCMOS33 [get_ports pmu_paden]
set_property IOSTANDARD LVCMOS33 [get_ports pmu_padrst]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_wakeup]

#####                gpioA define              #####
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpioA[0]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
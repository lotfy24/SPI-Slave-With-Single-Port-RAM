vlib work
vlog SPI_Wrapper.v SPI_Slave.v Ram.v SPI.v
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/tx_valid
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/tx_data
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/rx_valid
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/rx_data
add wave *
run -all
//quit -sim
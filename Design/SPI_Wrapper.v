module SPI_Wrapper (MOSI,SS_n,clk,rst_n,MISO);
// DEFINE PARAMETERS 
 parameter MEM_DEPTH = 256 ;
 parameter ADDR_SIZE = 8 ;
// DEFINE INPUTS
input MOSI,SS_n,clk,rst_n;
// DEFINE OUTPUT
output MISO;
// DEFINE INTERNAL WIRES 
wire [9:0] rx_data;
wire rx_valid,tx_valid;
wire [7:0] tx_data;
// INESTANTIATION RAM MODULE
Single_port_SYNC_RAM ram(rx_data,rx_valid,tx_data,tx_valid,clk,rst_n);
// INESTANTIATION SPI_slave_interface MODULE
SPI_slave_interface SPI(MOSI,MISO,SS_n,clk,rst_n,tx_valid,tx_data,rx_valid,rx_data);
endmodule
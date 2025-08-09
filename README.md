# SPI-Slave-With-Single-Port-RAM
Project Overview
This project implements an SPI Slave device with integrated single-port synchronous RAM, designed for FPGA or ASIC platforms. The SPI Slave interface communicates with an SPI Master using a custom protocol, while the RAM module allows data storage and retrieval.

The system enables commands from the SPI master to write to or read from the internal RAM, providing a flexible memory-mapped SPI slave solution.
Modules Description
1. SPI_slave_interface.v
Implements the SPI slave protocol as a finite state machine (FSM) with states for command checking, writing data, reading address, and reading data.

Handles SPI signals: MOSI (Master Out Slave In), MISO (Master In Slave Out), and SS_n (Slave Select, active low).

Interfaces with external data and control signals (tx_valid, tx_data, rx_valid, rx_data) for communication with the RAM module.

2. Single_port_SYNC_RAM.v
A synchronous single-port RAM module with parameterizable depth (default 256 words) and address size (8 bits).

Supports separate write and read address registers controlled by the SPI slave.

Writes or reads data based on commands received from SPI.

Signals tx_valid to indicate data ready to send back via SPI.

3. SPI_Wrapper.v
Top-level module that instantiates the SPI Slave interface and the RAM module.

Connects the SPI interface signals to the RAM module signals, managing data flow.

4. SPI_Wrapper_tb.v
Testbench module that validates SPI Slave and RAM functionality.

Simulates SPI write and read operations by sending 10-bit data packets with commands and data.

Initializes RAM contents from a hex file (mem.dat).

Checks for correctness of written and read data by comparing SPI interface data with RAM contents.

Uses clock, reset, and SPI signals to drive the DUT (Device Under Test) and monitor outputs.

SPI Protocol and Operation
SPI communication starts when SS_n goes low.

Commands and data are sent over MOSI; data to be sent back is shifted out on MISO.

The first two bits of each received 10-bit data word define the command type:

00: Set write address in RAM

01: Write data to RAM at the stored write address

10: Set read address in RAM

11: Read data from RAM at the stored read address and send back via SPI

The SPI slave FSM transitions through states to handle these operations, interfacing with the RAM module accordingly.

Features
Full SPI Slave implementation with 10-bit wide data packets.

Single-port synchronous RAM for flexible data storage.

Clear FSM design with distinct states for command, write, and read.

Parameterizable memory depth and address width.

Modular and easy to integrate design.

Comprehensive testbench to validate SPI and RAM functionality.

Usage
Top-Level Integration:

Use the SPI_Wrapper module as your top-level design.

Connect SPI signals (MOSI, MISO, SS_n), clock (clk), and reset (rst_n) as needed.

Simulation:

Use SPI_Wrapper_tb.v to simulate the design.

Initialize RAM contents using mem.dat file.

Run the testbench to verify SPI write and read commands.

Monitor outputs and internal signals for debugging.

Synthesis:

The design is synthesizable for FPGA or ASIC targets.

Customize parameters like MEM_DEPTH and ADDR_SIZE as required.

Files
SPI_slave_interface.v — SPI slave interface module.

Single_port_SYNC_RAM.v — Synchronous single-port RAM module.

SPI_Wrapper.v — Top-level module connecting SPI slave and RAM.

SPI_Wrapper_tb.v — Testbench module to simulate and verify functionality.

mem.dat — Hex file to initialize RAM contents during simulation.


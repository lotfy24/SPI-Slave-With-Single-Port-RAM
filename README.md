SPI Slave with Single Port RAM
Project Overview
Welcome to the SPI Slave with Single Port RAM project — a digital design that implements an SPI Slave device integrated with a synchronous single-port RAM using Verilog. This project facilitates communication between an SPI Master and internal RAM through standard SPI protocol commands.

Features
SPI Slave interface supporting MOSI, MISO, SS_n (active low), clock, and reset signals

Internal synchronous RAM with 256-byte depth and 8-bit wide data

Finite State Machine (FSM) to handle SPI read/write commands and data flow

Parameterized memory size and address width for flexibility

Supports write commands, read address reception, and data transmission

Robust reset and idle state management for reliable operation

Testbench included for functional verification

FSM States
The SPI Slave interface uses a finite state machine with the following states:

IDLE — Waits for SPI communication to start (SS_n high)

CHK_CMD — Checks the command bit to determine the operation type

WRITE — Receives 10-bit write data (address + data) to store in RAM

READ_ADD — Receives 10-bit read address from the SPI Master

READ_DATA — Sends data stored at the specified RAM address back to the Master

Repository Structure
graphql
Copy
Edit
├── SPI_Wrapper.v             # Top-level module integrating SPI interface and RAM
├── SPI_slave_interface.v     # SPI protocol FSM handling SPI commands and data
├── Single_port_SYNC_RAM.v    # Synchronous single-port RAM module
├── SPI_Wrapper_tb.v          # Testbench for SPI Slave and RAM verification
├── mem.dat                   # RAM initialization file (hex format) for simulation
Usage
Integration:
Connect your SPI Master signals to the SPI Slave ports:

MOSI — Master Out Slave In data line

MISO — Master In Slave Out data line

SS_n — Slave Select (active low)

clk — System clock

rst_n — Active low reset

Memory Configuration:
Adjust the parameters MEM_DEPTH and ADDR_SIZE to fit your memory size needs (default 256 bytes, 8-bit address).

Write Operation:

Master sends a write command (command bits = 00) followed by 8-bit address and 8-bit data in a 10-bit frame.

The SPI Slave stores the data at the specified address in RAM.

Read Operation:

Master sends a read address command (command bits = 10 for address, then 11 for data read).

The SPI Slave outputs the data stored at that address via MISO during the read data state.

Simulation:

Use the provided SPI_Wrapper_tb.v testbench to simulate SPI transactions and verify read/write correctness.

Initialize RAM with mem.dat file to preload memory before simulation.

Simulation
The SPI_Wrapper_tb.v testbench performs thorough verification by:

Initializing RAM from mem.dat

Sending SPI write commands with address and data pairs

Sending SPI read commands with address and validating MISO output

Checking internal signals for correctness

Reporting errors and halting on mismatch

Run the testbench in your simulator and observe outputs and waveforms to validate functionality.

Parameters
MEM_DEPTH (default: 256): RAM size in bytes

ADDR_SIZE (default: 8): Width of RAM address bus

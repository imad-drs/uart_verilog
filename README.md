# 📡 Verilog UART from Scratch

A fully functioning, synthesize-ready UART (Universal Asynchronous Receiver-Transmitter) module written entirely in Verilog.

This project was built from scratch to understand digital hardware design, state machines, and clock-domain timing.

## 🛠️ Features

- **Custom Baud Rate Generator:** Uses 16x oversampling for reliable data reception.
- **UART Transmitter:** State machine that serializes parallel data and adds start/stop bits.
- **UART Receiver:** State machine with mid-bit sampling to ignore wire noise.
- **Loopback Testbench:** A complete virtual environment to verify the transmitter and receiver can talk to each other.

## 🚀 How to Simulate Locally

This project is verified using **Icarus Verilog** and **GTKWave**.

1. **Compile the design and testbench:**
   iverilog -o uart_sim.vvp tb_uart_system.v uart_system.v baud_rate_generator.v transmitter.v receiver.v

2. **Run the simulation:**
   vvp uart_sim.vvp

3. **View the waveform:**
   gtkwave uart_waves.vcd

## 🧠 What I Learned

- Dealing with the "x" (unknown) state in Verilog simulators.

- Writing modular RTL code and wiring components together at the top level.

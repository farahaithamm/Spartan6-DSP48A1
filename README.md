# Spartan6 - DSP48A1

> **By:** Farah Haitham Saddik

This project implements a **DSP48A1 slice** for Xilinx Spartan-6 FPGAs using Verilog HDL, optimized for high-performance digital signal processing tasks such as multiply-accumulate (MAC) operations, filtering, and FFTs.  
The DSP48A1 is a dedicated arithmetic block capable of handling fast multiplication, addition, accumulation, and other DSP-related operations.



## Features

- Parameterized DSP48A1 slice implementation.
- Supports **synchronous** and **asynchronous** resets.
- Implements:
  - 18x18 high-speed multiplication
  - Addition & subtraction
  - Accumulation with pipeline registers
  - Flexible input multiplexing (A, B, C, D, OPMODE, Carry)
  - Cascade and direct input modes for B port
  - Carry-in/out with configurable source selection
- Fully synthesizable Verilog HDL.
- Modular design with reusable submodules.
- Testbench included for functional verification.

## Objective

Design, implement, and verify a DSP-like pipeline using Verilog HDL and the Xilinx DSP48A1 primitive, covering:
- Multiple DSP datapaths
- Configurable pipelining
- Functional and timing verification
- Waveform and schematic analysis

## Project Structure

```
├── constraints/           # Clock and pin constraint file (.xdc)
├── src/                   # Verilog source files
├── tb/                    # Testbench files
├── DSP48A1_Report.pdf     # Detailed project report
```

## Tools

- **QuestaSim** — Simulation
- **QuestaLint** — Linting
- **Xilinx Vivado** — Synthesis, Implementation, Bitstream generation

## Documentation

The complete project documentation — covering RTL design, testbench, simulation outputs, RTL, synthesis and device schematic, timing analysis and resource utilization — is detailed in `DSP48A1_Report.pdf`.

## Design Files

- `DSP48A1.v`: Top-level Verilog module for DSP48A1 slice implementation.
- `ff_mux.v`: Verilog implementation of the flip-flop and the MUX in the block diagram.
- `DSP48A1_tb.v`: Verilog testbench for simulation and verification.
- `run_dsp.do`: Script for automating the simulation process.

## Getting Started

To work with this project, you’ll need a **Verilog simulator** that supports the Spartan-6 FPGA architecture.  
**QuestaSim** is recommended for best results.

### 1. Quick Simulation (Recommended)

A preconfigured script `run_dsp.do` is provided to automate the simulation.

Steps:
1. Ensure your simulator is installed and licensed.
2. Open a terminal or simulator console.
3. Navigate to the project directory.
4. Run:
   do run_dsp.do
5. The script will:
   - Compile all Verilog files.
   - Load the testbench.
   - Run the simulation.
   - Display the waveform.

### 2. Manual Simulation (Optional)

1. Compile source files from `src/`.
2. Compile testbench files from `tb/`.
3. Load the top-level testbench (`DSP48A1_tb`).
4. Run the simulation and observe waveforms.

### 3. Testbench

- The provided `DSP48A1_tb.v` contains example DSP48A1 operations.
- Extend with custom vectors for more thorough testing.




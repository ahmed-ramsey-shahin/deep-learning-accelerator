# Deep Learning Hardware Accelerator

A hardware implementation of a deep learning accelerator using SystemVerilog/Verilog, designed for efficient neural network inference. This project implements a systolic array-based matrix multiplication unit with various activation functions and supporting components.

## Architecture Overview

The accelerator consists of the following key components:

### Core Components

1. **Matrix Multiply Unit**
   - Systolic array-based implementation
   - Efficient parallel processing
   - Integrated with Processing Elements

2. **Processing Elements**
   - Basic computational units
   - Optimized for matrix operations

3. **Multiplier Units**
   - Carry Save Multiplier
   - Wallace Tree Multiplier (8x8)

### Memory and Data Management

1. **Unified Buffer**
   - Input data storage and management
   - Efficient data distribution

2. **Weight FIFO**
   - Weight storage and distribution
   - Optimized for systolic array feeding

3. **Systolic Data Setup**
   - Data arrangement for systolic processing
   - Timing and synchronization management

### Activation Functions

- ReLU (Rectified Linear Unit)
- Sigmoid
- Softmax
- Tanh

## Project Structure

```
├── RTL/
│   ├── Activations/
│   │   ├── ReLU/                     # ReLU activation function
│   │   ├── Sigmoid/                  # Sigmoid activation function
│   │   ├── Softmax/                  # Softmax activation function
│   │   ├── Tanh/                     # Tanh activation function
│   │   └── Activations.v             # Top-level activation module
│   ├── Matrix_Multiply_Unit/
│   │   ├── Matrix_Multiply_Unit.sv    # Main matrix multiplication module
│   │   ├── Matrix_Multiply_Unit_tb.sv # Testbench for matrix multiply
│   │   ├── restart.do                # ModelSim restart script
│   │   ├── run.do                    # ModelSim simulation script
│   │   └── wave.do                   # ModelSim waveform configuration
│   ├── Multipliers/
│   │   ├── Carry_Save_Multiplier/    # Efficient multiplication unit
│   │   │   ├── Carry_Save_Multiplier.v   # Main multiplier implementation
│   │   │   ├── Carry_Save_Multiplier_tb.v # Testbench for multiplier
│   │   │   ├── Full_Adder.v             # Full adder component
│   │   │   ├── Math_Multiplier.v        # Mathematical multiplier logic
│   │   │   ├── run.do                   # ModelSim simulation script
│   │   │   └── wave.do                  # ModelSim waveform configuration
│   │   └── Wallace_Tree_Multiplier/  # 8x8 Wallace tree multiplier
│   │       ├── wallace_tree_multiplier_8x8.v    # Main 8x8 multiplier
│   │       ├── wallace_tree_multiplier_8x8_tb.v # Testbench for 8x8
│   │       ├── FA.v                    # Full adder component
│   │       ├── HA.v                    # Half adder component
│   │       └── run.do                  # ModelSim simulation script
│   ├── Processing_Element/
│   │   ├── Processing_Element.v      # Core PE computation unit
│   │   ├── Processing_Element_tb.v   # Testbench for PE
│   │   ├── run.do                    # ModelSim simulation script
│   │   └── wave.do                   # ModelSim waveform configuration
│   ├── Systolic_Data_Setup/
│   │   ├── Systolic_Data_Setup.sv    # Data arrangement module
│   │   ├── Systolic_Data_Setup_tb.sv # Testbench for data setup
│   │   ├── restart.do                # ModelSim restart script
│   │   ├── run.do                    # ModelSim simulation script
│   │   └── wave.do                   # ModelSim waveform configuration
│   ├── Unified_Buffer/
│   │   ├── Unified_Buffer.sv         # Input data buffer module
│   │   ├── Unified_Buffer_tb.sv      # Testbench for buffer
│   │   ├── restart.do                # ModelSim restart script
│   │   └── run.do                    # ModelSim simulation script
│   └── Weight_FIFO/                  # Weight storage and distribution
├── DFT/                              # Design For Test files
├── Formality/
│   ├── Post-DFT/                     # Post-DFT formal verification
│   ├── Post-PnR/                     # Post-Place&Route verification
│   └── Post-Synthesis/               # Post-Synthesis verification
├── PnR/                              # Place and Route files
└── Synthesis/                        # Synthesis scripts and reports
```

## Module Specifications

### Processing Element (PE)
Core computational unit for the systolic array.

**Parameters:**
- WIDTH: Bit width of input and weight data (default: 8)
- ACCUMULATOR_WIDTH: Bit width of accumulator for partial sums (default: 32)

**Inputs:**
- CLK: Clock signal
- ASYNC_RST: Asynchronous reset (active low)
- SYNC_RST: Synchronous reset (active high)
- EN: Enable signal for PE operation
- LOAD: Load weights signal
- Input[WIDTH-1:0]: Input data for multiplication
- Weight[WIDTH-1:0]: Weight data for multiplication
- PsumIn[ACCUMULATOR_WIDTH-1:0]: Partial sum input from previous computation

**Outputs:**
- ToRight[WIDTH-1:0]: Data passed to right PE in systolic array
- ToDown[WIDTH-1:0]: Data passed to PE below in systolic array
- Result[ACCUMULATOR_WIDTH-1:0]: Accumulated multiplication result

**Functionality:**
- Performs multiplication of input and weight using Carry Save Multiplier
- Accumulates results with incoming partial sums
- Supports both weight loading and computation modes
- Implements systolic data flow with registered outputs

### Systolic Data Setup
Data arrangement module for systolic array processing.

**Parameters:**
- WIDTH: Bit width of input data (default: 8)
- LENGTH: Size of input/output arrays (default: 256)

**Inputs:**
- CLK: Clock signal
- ASYNC_RST: Asynchronous reset (active low)
- SYNC_RST: Synchronous reset (active high)
- EN: Enable signal for data setup
- Inputs[WIDTH-1:0][0:LENGTH-1]: Input data array

**Outputs:**
- Outputs[WIDTH-1:0][0:LENGTH-1]: Arranged data for systolic processing

**Functionality:**
- Implements delay line network for systolic data arrangement
- Generates appropriate timing delays for each row
- Supports reset and enable control
- Maintains synchronized data flow for systolic array

### Matrix Multiply Unit
Systemic array implementation for matrix multiplication.

**Inputs:**
- CLK: Clock signal
- ASYNC_RST: Asynchronous reset (active low)
- SYNC_RST: Synchronous reset (active high)
- EN: Enable signal for matrix multiplication
- LOAD: Load weights signal
- Inputs[WIDTH-1:0][LENGTH-1:0]: Input matrix data
- Weights[WIDTH-1:0][LENGTH-1:0]: Weight matrix data

**Outputs:**
- Result[ACCUMULATOR_WIDTH-1:0][LENGTH-1:0]: Output matrix containing multiplication results

### Multiplier Units

#### Carry Save Multiplier
Efficient multiplication unit optimized for high-speed operation using carry-save architecture.

**Parameters:**
- WIDTH: Bit width of input operands (default: 8)

**Inputs:**
- A[WIDTH-1:0]: First operand for multiplication
- B[WIDTH-1:0]: Second operand for multiplication

**Outputs:**
- P[2*WIDTH-1:0]: Product of multiplication

**Functionality:**
- Implements carry-save addition for partial products
- Uses Math_Multiplier sub-modules for bit-level operations
- Generates and accumulates partial products efficiently
- Produces double-width output for full precision

**Files:**
- Carry_Save_Multiplier.v: Main implementation
- Math_Multiplier.v: Bit-level multiplication logic
- Full_Adder.v: Full adder component

#### Wallace Tree Multiplier (8x8)
High-performance 8x8 bit multiplier using Wallace tree architecture for fast partial product reduction.

**Inputs:**
- A[7:0]: First 8-bit operand
- B[7:0]: Second 8-bit operand

**Outputs:**
- P[15:0]: 16-bit product result

**Functionality:**
- Implements Wallace tree algorithm for partial product reduction
- Uses half adders (HA) and full adders (FA) for efficient compression
- Organizes computation in 7 reduction stages
- Achieves high-speed multiplication through parallel processing
- Optimized for 8x8 bit multiplication with minimal latency

**Components:**
- Half Adders (HA): For 2-input addition without carry-in
- Full Adders (FA): For 3-input addition with carry propagation

## Implementation Flow

1. **RTL Development**
   - Component-level implementation
   - Unit testing and verification

# 5-Stage Pipelined Processor Design

## Project Overview

Welcome to the 5-Stage Pipelined Processor Design project! This project focuses on creating a RISC-like processor with an 8-register set, utilizing a 5-stage pipeline architecture. The processor supports a variety of instructions, memory operations, and branch control, following a specific Instruction Set Architecture (ISA).

### Features

- 5-stage pipelined architecture
- RISC-like ISA with 8 general-purpose registers, program counter (PC), and stack pointer (SP)
- Memory address space of 4 KB with 16-bit width
- 32-bit data bus between memory and the processor
- Interrupt handling and reset signals
- Instruction set including arithmetic, logic, memory operations, branching, and control operations

## ISA Specifications

### Registers

- `R[0:7]<31:0>`: Eight 32-bit general-purpose registers
- `PC<31:0>`: 32-bit program counter
- `SP<31:0>`: 32-bit stack pointer
- `CCR<3:0>`: Condition code register
- `Z<0>`: Z = CCR<0> (zero flag)
- `N<0>`: N = CCR<1> (negative flag)
- `C<0>`: C = CCR<2> (carry flag)

### Input-Output

- `IN.PORT<31:0>`: 32-bit data input port
- `OUT.PORT<31:0>`: 32-bit data output port
- `INTR.IN<0>`: Single, non-maskable interrupt
- `RESET.IN<0>`: Reset signal

### Additional Instructions

#### One Operand

- `NOP`: PC ← PC + 1 (Opcode: `00 0000`)
- `NOT Rdst`: R[Rdst] ← 1’s Complement(R[Rdst]) (Opcode: `00 0001`)
- `NEG Rdst`: R[Rdst] ← 0 - R[Rdst] (Opcode: `00 0010`)
- `INC Rdst`: R[Rdst] ← R[Rdst] + 1 (Opcode: `00 0011`)
- `DEC Rdst`: R[Rdst] ← R[Rdst] – 1 (Opcode: `00 0100`)
- `OUT Rdst`: OUT.PORT ← R[Rdst] (Opcode: `00 0101`)
- `IN Rdst`: R[Rdst] ← IN.PORT (Opcode: `00 0110`)

#### Two Operands

- `SWAP Rsrc, Rdst`: Swap values between Rsrc and Rdst without changing flags (Opcode: `01 0000`)
- `ADD Rdst, Rsrc1, Rsrc2`: Add values in Rsrc1 and Rsrc2, store result in Rdst (Opcode: `01 0001`)
- `ADDI Rdst, Rsrc1, Imm`: Add Rsrc1 to Immediate Value, store result in Rdst (Opcode: `01 0010`)
- `SUB Rdst, Rsrc1, Rsrc2`: Subtract Rsrc2 from Rsrc1, store result in Rdst (Opcode: `01 0011`)
- `AND Rdst, Rsrc1, Rsrc2`: Bitwise AND between Rsrc1 and Rsrc2, store result in Rdst (Opcode: `01 0100`)
- `OR Rdst, Rsrc1, Rsrc2`: Bitwise OR between Rsrc1 and Rsrc2, store result in Rdst (Opcode: `01 0101`)
- `XOR Rdst, Rsrc1, Rsrc2`: Bitwise XOR between Rsrc1 and Rsrc2, store result in Rdst (Opcode: `01 0110`)
- `CMP Rsrc1, Rsrc2`: Compare Rsrc1 and Rsrc2 without changing flags (Opcode: `01 0111`)
- `BITSET Rdst, Imm`: Set the specified bit in Rdst, update carry (Opcode: `01 1000`)
- `RCL Rsrc, Imm`: Rotate left Rsrc by Imm bits with carry (Opcode: `01 1001`)
- `RCR Rsrc, Imm`: Rotate right Rsrc by Imm bits with carry (Opcode: `01 1010`)

#### Memory Operations

- `PUSH Rdst`: M[SP--] ← R[Rdst] (Opcode: `10 0000`)
- `POP Rdst`: R[Rdst] ← M[++SP] (Opcode: `10 0001`)
- `LDM Rdst, Imm`: Load Immediate Value to Rdst (Opcode: `10 0010`)
- `LDD Rdst, EA`: Load value from memory address EA to Rdst (Opcode: `10 0011`)
- `STD Rsrc, EA`: Store value in Rsrc to memory location EA (Opcode: `10 0100`)
- `PROTECT Rsrc`: Protect memory location pointed at by Rsrc (Opcode: `10 0101`)
- `FREE Rsrc`: Free a protected memory location pointed at by Rsrc (Opcode: `10 0110`)

#### Branch and Control Operations

- `JZ Rdst`: Jump if zero (Opcode: `01 0000`)
- `JMP Rdst`: Unconditional jump (Opcode: `01 0001`)
- `CALL Rdst`: Call subroutine, saving return address on stack (Opcode: `01 0010`)
- `RET`: Return from subroutine (Opcode: `01 0011`)
- `RTI`: Return from interrupt, restoring flags (Opcode: `01 0100`)

## Hazard Control

Our processor design places a strong emphasis on efficient hazard control mechanisms to ensure smooth and uninterrupted operation. Two crucial components contribute to this: the Full Forwarding Unit and the ALU-to-ALU Forwarding Unit.

### Full Forwarding Unit

The Full Forwarding Unit is a robust solution designed to address data hazards within the pipeline. It facilitates the direct forwarding of data from the output of one stage to the input of another, effectively mitigating delays caused by dependencies. This feature significantly enhances the overall performance of the processor by minimizing stalls and maximizing instruction throughput.

### ALU-to-ALU Forwarding Unit

The ALU-to-ALU Forwarding Unit is specifically engineered to tackle hazards associated with Arithmetic Logic Unit (ALU) operations. By efficiently forwarding results from one ALU to another, this unit eliminates potential bottlenecks caused by dependencies between consecutive ALU operations. The strategy employed by this unit results in the reduction of idle cycles, ensuring optimal utilization of the processor's capabilities.


## Assembler

-A high-performance and reliable assembler. Our custom assembler swiftly converts assembly programs (text files) into machine code, ensuring a seamless integration with the processor's design.
you can run our assembler script on any assembly program to generate the machine code for it using:
```bash
      python assembler.py
```
## Our processor design

![Hazards drawio](https://github.com/RawanMostafa08/5-stage-pipelined-processor/assets/97397431/c9906bbb-cb7f-412b-8d44-220a04ae949e)

## How to Use

1. Clone the repository:

```bash
git clone https://github.com/yourusername/5-stage-pipelined-processor.git

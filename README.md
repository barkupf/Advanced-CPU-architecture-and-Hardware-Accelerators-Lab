# Advanced-CPU-architecture-and-Hardware-Accelerators-Lab
This repository contains VHDL code for various CPU architecture lab tasks.
Each task folder contains both the task files provided for the task and the submission files.

## Table of contents 🔗
- [Structure](#Structure)
- [Labs](#Labs)
    - [Lab 1](#Lab_1)
    - [Lab 2](#Lab_2)

 ## Structure
For each Lab task will be 2 folders:
- Lab_`j`_task will contain the task files that were given by Hanan Ribo, including task instruction and any starter code.
- Lab_`j`_sub will contain the final submission folders:
    1. DUT: contains the VHDL code.
    2. SIM: contains the simulation files that are used for the test benches.
    3. TB: contains the VHDL code of the test benches.

when `j` represents the lab number.

 ## Labs

 ### Lab 1
 #### Aim of the Laboratory:
  - Obtaining skills in VHDL code (part 1, which contains Code Structure, Data Types, Operators and Attributes, Concurrent Code, Design Hierarchy, Packages and Components).
  - Obtaining basic skills in ModelSim (multi-language HDL simulation environment).
  - General knowledge rehearsal in digital systems.
  - Proper analysis and understanding of architecture design.
#### Lab task:
Design a module which contains the next three sub-modules:
1. Generic Adder/Subtractor module between two vectors Y, X of size n-bit (the default is n=8).
2. Generic Shifter module based on Barrel-Shifter n-bit size (the default is n=8).
3. Boolean Logic operates bitwise.
The generic n value must be verified for 4,8,16,32 (set from tb.vhd file). You are required to design the whole system and make a test bench for testing.

### Lab 2
#### Aim of the Laboratory:
- Obtaining skills in VHDL code (part 2, which contains Sequential code and Behavioral modeling).
- Obtaining basic skills in ModelSim (multi-language HDL simulation environment).
- Knowledge in digital systems design.
- Proper analysis and understanding of architecture design.
#### Lab task:
Design a synchronous digital system which detects valid sub series for a given
condition value. You are required to design the whole system and make a test bench for testing.

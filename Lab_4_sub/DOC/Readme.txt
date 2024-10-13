
Lab 4- FPGA based Digital Design Read Me
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
In this laboratory you will have to synthesize a Synchronous Digital System based on LAB1 assignment
for the Cyclone II FPGA with impact on performance and logic usage.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Top Module: "top.vhd"

Input: Signal x_i, Signal y_i (Logic vectors size N), Signal ALUFN_i (Logic vectors size 5), ena, rst, clk (logic)
Output: ALUout_o (Logic vector size n), PW,_out, Nflag_o,Cflag_o,Zflag_o,Vflag_o (Logic)

The Module selects a sub module base on ALUFN_i[4:3], and initializes it with input x,y, and ALUFN_i[2:0]. 
Then, It lights the flags according to the output of the sub-module
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Adder Module "AdderSub.vhd": Activated when ALUFN_i[4:3] = "01". Based on ALUFN_i[2:0], either adds or substracts the 
X,Y vectors (adds: "00", subtracts: "01", return negative x: "10") using a FA adder.
Returns result and carry.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FA adder "FA.vhd": Adds two bits with a carry, inputs the addition if the bits and further carry
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Shifter Module "Shifter.vhd": Activated when ALUFN_i[4:3] = "10". Based on ALUFN_i[2:0], selects shift direction (left: "000", right:"001"). 
Shifts y to selected direction a certain amount of times specified in x[k-1:0]\
Returns result and carry.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Logic Module "Logic.vhd": Activated when ALUFN_i[4:3] = "11". Based on ALUFN_i[2:0], 
does a basic logic function on X,Y (not(y): "000", or(x,y):"001" , and(x,y): "010", xor(x,y): "011", nor(x,y): "100", nand(x,y):"101", xnor(x,y): "111"
Returns result.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Package "aux_package.vhd" : Organizes all the modules in the form ofcomponents in a package.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Input output top module, "IOtop.vhd": Responsible for connecting relevant input/output signals to relevant names, for when the hardware is connected, sending X,Y and ALU_out 
to "Decoder_to_HEX.vhd" and is resposible for sending the input to X,Y,ALUFN based on button pushed
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Binary to seven segment digit hex representation module, "Decoder_to_HEX.vhd": Translates the inputed 4 digit binary number to th seven segment hex representation,
to be outputed on the screen by the Input output top module.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Register module, "Register.vhd": The module replicates a register, where data can be read from it and entered to it. Has an enable, reset and clock feature.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
n-bit counter, "n_bit_counter.vhd": Counts up to entered limit_1. If either limit_0 or limit_1 have been changed, it resets. Has an enable, reset and clock feature. 
Outputs the number counted up until current point.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
PWM module, "PWM.vhd": The module counts up to Y_i, using the n-bit counter. if the mode is 0, the output is 0 when the counter is under X_i and 1 when betweeen X-i and Y_i.
When the mode is 1, it is 1 when the counter is under X_i, and o when between X_i and Y_i.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

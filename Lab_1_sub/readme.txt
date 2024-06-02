
Lab 1- VHDL part 1, concurrent code Read Me
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
In this lab, we learned and utelized the basic of of VHDL, by making a number of modules and an interface for using and selecting them. 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Top Module: "top.vhd"

Input: Signal x, Signal y (Logic vectors size N), Signal ALUFN_i (Logic vectors size 5)
Output: ALUout_o (Logic vector size n), Nflag_o,Cflag_o,Zflag_o,Vflag_o (Logic)

The Module selects a sub module base on ALUFN_i[4:3], and starts it with input x,y, and ALUFN_i[2:0]. 
Then, It lights the flags according to the output of the sub-module
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Adder Module "AdderSub.vhd": Activated when ALUFN_i[4:3] = "01". Based on ALUFN_i[2:0], either adds or substracts the 
X,Y vectors (adds: "00", subtracts: "01", return negative x: "10") using a FA adder.
Returns result and carry.
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
FA adder "FA.vhd": Adds two bits with a carry, inputs the addition if the bits and further carry
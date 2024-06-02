
Lab 1- VHDL part 2, Sequential code and Behavioral modeling
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
In this lab, we furthured our knowledge of VHDL code and ModelSim, while buiding a flip-flop based algorithm

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Top Module: "top.vhd"

Generic: m (positive, default 8), m (positive, default 7), k (positive, default 3)
Input: rst,ena,clk  (std_logic), x (std logic vector size n), detection code (integer 0 to 3)
Output: detector (std logic)

The module works by the rythm of the clk input, and turns on the output detector if the last 7 input pairs have the right distance, determined by the detection code.
It works with 3 processes. The first takes a stream of inputs, and loads pairs (the last input and the second to last) to be used by the next proccess.
The second proccess subtracts the second to last input from the last on. If the difference the right one, in accordance to the detection code (detection code +1) then it turns the valid bit signal
The third proccess counts how many clock cycles the valid bit has been turned on in a row. If it is at least 7, then it turns on the output detector.
If rst (reset) is turned on, all signals are 0 and the count that has happened till now is reset.
If the ena in off, the module will 'pause' until it is turned on.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Adder Module "AdderSub.vhd"
Genric: length (int, default 8)
input: a, b (std logic vectors of length "length"), cint (std logic)
output: s (std logic vector length "length"), cout (std logic)
the module adds the two vectors a and b with a starting carry of cin (useful for subtraction), and outputs the solution and carry.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Package "aux_package.vhd" : Organizes all the modules in the form of components in a package.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
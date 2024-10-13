
Lab 3- Digital System Design with VHDL Read Me
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Program Memory module, "progMem.vhd"
input: clk, memEn (logic), WmemData (logic vector dwidth sized), WmemAddr, RmemAddr (logic vector A width sized)
output: RmemData (logic vector Dwidth sized)
Access to program memory, using the PC.

FA Module: "FA.vhd"

Input: xi, yi, cin (Logic)
Output: s, cout (Logic)

The module adds the two entered bits with a carry, outsputs the result and following carry. Basic part of adderSub.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Data memory module "DataMem.vhd":
input: clk, memEn (logic), WmemData (logic vector dwidth sized), WmemAddr, RmemAddr (logic vector A width sized)
output: RmemData (logic vector Dwidth sized)
Access to data memory. Reads on every clock rise according to given address.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Program Counter module, "PcReg.vhd"
input: IRoffset (logic vector sized offset_size), PCsel (logic vector sized 2), clk, PCin (logic)
output: PCout (logic vector sized 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Instruction register Module: "IR.vhd":
input: command (logic vector sized width), RFaddr (logic vector sized 2) IRin (logic)
output: opcode (logic vector sized opCodeWidth), RFAddrout (logic vector sized rwidth), offsetAddress (logic vector sized offsetWidth), immOut (logic vector sized Immwidth)
when enabled, splits the command into opcode, register file address (according to which one is needed), off set address and immidiate out. 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Decoder Module "decoder.vhd": 
input: OpCode (logic vector size Opsize)
output: add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done (logic)
Turns on the related bit to the operation represented in opcode
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Alu module, "ALU.vhd"
input: A, B (logic vector length sized), OPC (logic vector 4 sized)
output: C (logic vector length sized, Cflag, Zflag, Nflag (logic)
The module calculates either the addition, subtraction (B - A), and, or or xor of A and B, according to OPC.
uses the module AdderSub
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Control module, "control.vhd"
input:clk, rst, ena, add,sub, andd, orr, xorr, jmp, jc, jnc, mov, ld, st, done, Nflag,Zflag, Cflag (logic),
output: mem_in, mem_wr,  memOut, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in, fsmDone (logic), RFaddr, PCsel (logice vector sized 2), OPC (logic vector sized opCodeWidth)
The module tracks and advances the FSM according to the input and the current state. I does so by sending
enable/disable outputs to the different modules to keep all programs on track
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Adder/Subber Module "AdderSub.vhd":
Input: x, y (logic vector of size n), sub_cont (logic vector of size 3)
Output: 	res (logic vector of size n), cout (logic)
The module either adds or subtracts x and y, according to the sub_cont. 
if the sub_cont is "001" or "010",  it subtracts y from x, otherwise it adds y and x
The result is outputed to res, and the carry to cout
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Package "aux_package.vhd" : Organizes all the modules in the form of components in a package.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Bi-directional pin Module "BiDirPin".vhd": 
input: Dout (logic vector sized width), en (logic)
output: Din (logic vector sized width)
in/out: IOpin (logic vector sized width)
The module outputs IOpin into Din and then if enable is on Dout to IOpin
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Basic Bi-directional pin Module "BiDirPinBasic.vhd": 
input: writePin (logic)
output: readPin (logic)
in/out: bdirPin (logic)
The module outputs bidirPin into readPin and then writePin to bidirPin
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Master slave register module, "MS_Register.vhd":
input: clk,Enin,rst (logic), RegIn (logic vector Dwidth sized
out: RegOut (logic vector sized Dwidth)
on rising edge the Master register updates to the value of the input, 
and the output updated to the value of the Slave register.
on falling edge the Slave register updates to the value of the Master register.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Dflop module, "Dflop.vhd"
input: clk, En, rst (logic), D (logic vector sized Dwidth)
output: Q (logic vector sized Dwidth)
On clock rise and enable on the module updated D to Q, on reset returns to 0 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Register Module "Register.vhd":
input: clk, En, rst (logic), Rin (logic vecotr sized Dwidth)
output: Rout (logic vector sized Dwidth)
on rising edge the register updates to the input value (if enable is on)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Register file module,  "RF.vhd" 
input: clk, rst, WregEn (logic), WregData (logic vector sized Dwidth)
output: regAddr, RregAddr (logic vector sized Awidth), RregData (logic vector sized Dwidth)
Controls the register file as an array of registers
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Top module "Top.vhd"
input: clk, rst, ena,TBactive, TBProgmem_wren, TBDatamem_wren (logic), TBProgmem_datain (logic vector sized m), 
TBDatamem_datain (logic vector sized n), TBProgmem_writeaddr, TBDatamem_writeaddr, TBDatamem_readaddr, (logic vector sized Awidth)
output: FSM_done (logic), TBDatamem_dataout (logic vector sized n)
Combines all parts of the FSM, using the modules Control and Datapath.
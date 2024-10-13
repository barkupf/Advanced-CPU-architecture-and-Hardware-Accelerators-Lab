library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------
--the decoder input is the op code and the output is conecting to the control unit
-- getting the opcode (the 4 MSB's) from the IR register: IRreg(BusSize-1 downto BusSize-RegSize) = Last 4 bits of IR register 
entity DECOD is
generic( Dwidth: integer:=16;
		 Opsize: integer:=4);
port(	OpCode : in std_logic_vector(Opsize-1 downto 0);
		add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done	: out std_logic	
);
end DECOD;  
--------------------------------------------------------------
architecture decoder of DECOD is
begin

	add		<=	'1'	when OpCode = "0000" else '0';
	sub		<=	'1'	when OpCode = "0001" else '0';
	andd	<=	'1'	when OpCode = "0010" else '0';
	orr		<=	'1'	when OpCode = "0011" else '0';
	xorr	<=	'1'	when OpCode = "0100" else '0';
	--TB	<=	'1'	when OpCode = "0101" else '0'; R-type unused
	--TB	<=	'1'	when OpCode = "0110" else '0'; R-type unused
	jmp		<=	'1'	when OpCode = "0111" else '0';
	jc		<=	'1'	when OpCode = "1000" else '0';
	jnc		<=	'1'	when OpCode = "1001" else '0';
	--TB	<=	'1'	when OpCode = "1010" else '0'; J-type unused
	--TB	<=	'1'	when OpCode = "1011" else '0'; J-type unused
	mov		<=	'1'	when OpCode = "1100" else '0';
	ld		<=	'1'	when OpCode = "1101" else '0';
	st		<=	'1'	when OpCode = "1110" else '0';
	done	<=	'1'	when OpCode = "1111" else '0';

end decoder;
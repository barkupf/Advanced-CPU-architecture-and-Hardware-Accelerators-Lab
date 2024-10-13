library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity IR is
	generic( width: integer:=16;  --size of IR
			opCodeWidth: integer :=4; 
			rwidth: integer:= 4; --register code size
			ImWidth: integer := 8;
			offsetWidth: integer := 8
			);
	port(   command: in 	std_logic_vector(width-1 downto 0); --instruction
			IRin:	in 		std_logic;                          --enable input
			RFaddr: in std_logic_vector(1 downto 0);            --selects ra, rb, rc
			opcode: out std_logic_vector(opCodeWidth-1 downto 0);  --opcode out
			RFAddrOut:	out	 std_logic_vector(rwidth-1 downto 0); --register out
			offsetAddress: out std_logic_vector(offsetWidth-1 downto 0);
			immOut: out std_logic_vector(ImWidth-1 downto 0)
	);
end IR;

architecture comb of IR is
signal commandTemp: std_logic_vector (width-1 downto 0);
begin 
	commandTemp <= command when IRin = '1' else unaffected;
	opcode <= commandTemp(width-1 downto width-opCodeWidth);
	with RFAddr select
		RFAddrOut <= commandTemp(rwidth-1 downto 0) when "10",  --c    
					 commandTemp(2*rwidth-1 downto rwidth) when "01",  --b
					 commandTemp(3*rwidth-1 downto 2*rwidth) when others; --a
	immOut <= commandTemp(ImWidth-1 downto 0); --for I type. When using the small immidiate version, take smaller part
	offsetAddress <= commandTemp(offsetWidth-1 downto 0); --for J type
					
	
end comb;


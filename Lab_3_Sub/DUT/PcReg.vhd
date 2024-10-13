library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------
-- PC register 
-- on rising edge the PC updates to the next value that selected by PCsel
entity PCReg is
generic( Awidth: integer:=6;
		 offset_size: integer:=8
		);
port(	clk,PCin: in std_logic;
		PCsel: in std_logic_vector(1 downto 0);
		IRoffset  : in std_logic_vector(offset_size-1 downto 0);
		PCOut  : out std_logic_vector(Awidth-1 downto 0)
);
end PCReg;  
--------------------------------------------------------------
architecture dfl of PCReg is
signal 	PCcurr,PCnext : std_logic_vector(Awidth-1 downto 0) := (others=>'0');
signal	offset : std_logic_vector(offset_size-1 downto 0) := (others=>'0');
begin
next_PC:	with PCsel select
				PCnext 	<= 	PCcurr+1 when "00", -- PC+1
							PCcurr+1+SXT(IRoffset,Awidth) when "01", -- PC+1+IR<7...0>
							(others=>'0') when "10", -- reset PC
							unaffected when others;
			  
update_PC:	process(clk)
			begin
				if (clk'event and clk='1') then
					if (PCin='1') then
						PCcurr <= PCnext;
					end if;
				end if;
			end process;
	PCOut <= PCcurr;
	offset <= IRoffset;
	
end dfl;
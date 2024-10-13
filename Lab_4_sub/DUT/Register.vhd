library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------
-- regluar register:
-- on rising edge the register updates to the input value (if enable is on)
entity Reg is
generic( Dwidth: integer:=16);
port(	clk,Ein,rst: in std_logic;	
		Rin  : in std_logic_vector(Dwidth-1 downto 0);
		Rout  : out std_logic_vector(Dwidth-1 downto 0)
);
end Reg;  
--------------------------------------------------------------
architecture behav of Reg is
begin
	process(clk,rst)
	begin
		if (rst = '1') then
			Rout <= (others=>'0');
		elsif (clk'event and clk='1') then
			if (Ein='1') then
				Rout <= Rin;
			end if;
		end if;
	end process;
	
end behav;
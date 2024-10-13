library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------
--D flip flop: Q=D 
entity Dflop is
generic( Dwidth: integer:=16);
port(	clk,En,rst: in std_logic;	
		D  : in std_logic_vector(Dwidth-1 downto 0);
		Q  : out std_logic_vector(Dwidth-1 downto 0)
);
end Dflop;  
--------------------------------------------------------------
architecture behav of Dflop is
begin
	process(clk)
	begin
		if (rst='1') then
			Q <= (others=>'0');
		elsif (clk'event and clk='1') then
			if (En='1') then
				Q <= D;
			end if;
		end if;
	end process;
	
end behav;
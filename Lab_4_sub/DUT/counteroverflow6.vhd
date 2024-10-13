library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
USE work.aux_package.all;
-------------------------------------
entity counteroverflow6 is port (
	clk,enable,rst : in std_logic;	
	q         	   : out std_logic); 
end counteroverflow6;
------------------------------------
-- we want the frequency of the out put to be 31.25 KHz => the time period of the out put is 32us => with duty cycel of 50% we need 
-- to make sure that the counter, when oveflow, to change the out put sign every 16 us. we get from the PLL is 2MHz => the time period is 0.5us.
-- we increase the counter every rising edge of the clock => every 0.5us, so to get to 16us we need to count to 32 => the q_int lenght needs to be 5 bits.
------------------------------------ 
architecture rtl of counteroverflow6 is
    signal q_int	: std_logic_vector(4 downto 0):=(others=>'0');
	signal check	: std_logic_vector(4 downto 0):=(others=>'1');  
begin
    process (clk,rst)
	variable bout : std_logic:='0';
    begin
		if (rst='1') then
			q_int <= (others=>'0');
			bout := '0';
        elsif (rising_edge(clk)) then	   
		        q_int <= q_int + 1;
				if (q_int=check) then
					bout := not(bout);
				end if;
	    end if;
		q <= bout;
    end process;
end rtl;




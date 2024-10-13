library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
USE work.aux_package.all;
-------------------------------------
entity CounterEnvelope is port (
	Clk,En,rst : in std_logic;	
	Qout  	   : out std_logic); 
end CounterEnvelope;
-------------------------------------
architecture rtl of CounterEnvelope is	 
    signal PLLOut : std_logic ;
begin
    m0:	counteroverflow6 port map(PLLOut,En,rst,Qout);
	m1:	PLL port map(
	     inclk0 => Clk,
		  c0 => PLLOut
		);
end rtl;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
entity PWM is
  generic (n : integer := 8);
  port 
  (  
		Y_i,X_i					: 	in std_logic_vector (n-1 downto 0);
		ena,rst,clk				:	in std_logic;
		PWM_mode				: 	in std_logic_vector(1 downto 0);
		PWM_out					:	out	std_logic
	
  );
end PWM;
-----------------------------------------------------------
architecture struct of PWM_tog is 

	signal 	PWM_out_org,PWM_out_tog		:	std_logic;
	
begin
	
PWM_original:	PWM_org generic map(n)	port map(Y_i,X_i,ena,rst,clk,PWM_mode(0),PWM_out_org);

PWM_toggle:		PWM_tog generic map(n)	port map(Y_i,X_i,ena,rst,clk,PWM_out_tog);

output:		with PWM_mode select
					PWM_out <=  PWM_out_tog when "10",
								PWM_out_org when others;
	
	
end struct;
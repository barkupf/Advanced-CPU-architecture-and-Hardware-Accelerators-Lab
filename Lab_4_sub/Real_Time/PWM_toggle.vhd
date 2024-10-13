LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
entity PWM_tog is
  generic (n : integer := 8);
  port 
  (  
		Y_i,X_i					: 	in std_logic_vector (n-1 downto 0);
		ena,rst,clk				:	in	std_logic;
		PWM_out					:	out	std_logic
	
  );
end PWM_tog;
-----------------------------------------------------------
architecture struct of PWM_tog is 

					signal	counter,X_i_prev,Y_i_prev	:	std_logic_vector(n-1 downto 0); -- counter					
begin

connect_counter:	counter_nbit generic map(n) port map(clk,ena,rst,X_i_prev,Y_i_prev,counter); -- conecting to counter
		
		process(clk,rst)
		variable temp_out : std_logic:='0';
		begin
			if(rst='1') then		-- reset => output = 0
				temp_out:='0';
			elsif(clk'event and clk='1') then
				if ((not(X_i_prev=X_i))or(not(Y_i_prev=Y_i))) -- if inputs change then start from the begining, and update
					if (ena='1') then
						X_i_prev <= X_i;
						Y_i_prev <= Y_i;
						temp_out := '0';
					end if;
				end if;
				if (X_i_prev = counter) then  -- when counter gets to X toggle
					temp_out := not(temp_out);
				end if:
			end if;
			PWM_out <= temp_out;
		end process;		

end struct;
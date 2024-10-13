LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------------------------------------------------------------------
------------------------------------------PWM Unite---------------------------------------------
------------------------------------------------------------------------------------------------
-- This unit get as input:
-- (1) two number - X_i and Y_i (Y_i > X_i otherwise the input is ilegal)
-- (2) enable and reset bits and clock
-- (3) oporation mode bit - PWM_mode
-- and the unit has one output - PWM_out

-- the unit connects to a counter that set to count up untill Y_i 
-- if the unit is in mode 0 (=> PWM_mode=0), the unit output wil be:
-- { 0 when counter < X_i, 1 when X_i < counter < Y_i 
-- if the unit is in mode 1 (=> PWM_mode=1), the unit output wil be:
-- { 1 when counter < X_i, 0 when X_i < counter < Y_i 
-- becuase the system oporation modes are symmetrical, we use the PWM_mode to change the output.

-- in case of changing the X_i,Y_i input, we start the oporation from the begining (reset countint and adjusting the output accordantly).
-- in case of change of the oporation mode we change the output accordantly to the legality of the mode (that describe above), but we do not
-- reset the unit(exsampel: if we were in mode 0, X_i=1,Y_i=3, and when the counter=2 we change the mode to be mode 1, then the output is:
-- 0 when 0<=counter<1, 1 when 1<=counter<2, 0 when 2<=counter<3, 1 when 0(new counting set)<=counter<1).   
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
entity PWM is
  generic (n : integer := 8);
  port 
  (  
		Y_i,X_i					: 	in std_logic_vector (n-1 downto 0);
		ena,rst,clk,PWM_mode	:	in	std_logic;
		PWM_out					:	out	std_logic
	
  );
end PWM;
-----------------------------------------------------------
architecture struct of PWM is 

					signal	counter,X_i_prev,Y_i_prev	:	std_logic_vector(n-1 downto 0); -- counter
					signal  zero				  		:	std_logic_vector(n-1 downto 0):=(others=>'0'); -- zero vector
					signal	PWM_mode_prev				:	std_logic;
begin

connect_counter:	counter_nbit generic map(n) port map(clk,ena,rst,X_i_prev,Y_i_prev,counter); -- conecting to counter

						process(clk,rst)
						variable temp_out : std_logic:=PWM_mode;
						begin
							if(rst='1') then								-- reset => output = 0
								temp_out:='0';
							elsif(clk'event and clk='1') then				
								if (Y_i_prev > X_i_prev) then						-- make sure input is legal before changing
									if ((counter=X_i_prev)and(not(X_i_prev=zero))) then -- if X_i is 0 then we dont want to change 
										temp_out := not(PWM_mode_prev);			-- we are "at the time" between X_i and Y_i => output = not(mode) 
									elsif (counter=Y_i_prev) then			-- we are "at Y_i" => we start counting from the beginning =>
										if (not(X_i_prev=zero)) then 		-- => output = mode (only if X_i is not 0)
											temp_out := PWM_mode_prev;
										else
											temp_out := not(PWM_mode_prev);	-- if X_i is 0 the output need to be not(mode)
										end if;											
									end if;
								end if;
								if (not(PWM_mode_prev = PWM_mode)) then
									if ((ena='1')and(rst='0')) then
										PWM_mode_prev <= PWM_mode;
										temp_out := not(temp_out);		   			-- so it matches the logic of set/reset or reset/set
									end if;
								end if;
								if ((not(X_i=X_i_prev))or(not(Y_i=Y_i_prev))) then
									if ((ena='1')and(rst='0')) then
										X_i_prev <= X_i;
										Y_i_prev <= Y_i;
										if (Y_i>X_i) then						   	-- if input is legal then:
											if (X_i=zero) then						-- if X_i is 0 the output need to be not(mode)
												temp_out := not(PWM_mode);			-- because we always "at the time" between X_i and Y_i
											else 
												temp_out := PWM_mode;				-- if X_i is not 0, we start from the beginning so 
											end if;									-- the output need to be the mode
										else
											temp_out := PWM_mode;					-- if input is not legal, we will never be "at the time"
										end if;										-- between X_i and Y_i so output need to be the mode
									end if;
								end if;
							end if;
							PWM_out<=temp_out;										-- set the output
						end process;
end struct;
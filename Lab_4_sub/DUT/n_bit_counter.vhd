library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
---------------------------------------------------------
-------------------n bit counter ------------------------
---------------------------------------------------------
-- this is n bit counter. the input are 2 n-bits signals(limit_0 and limit_1), enable and reset bits and a clock.
-- the output of this counter is the counting. the max number the counter can count to is (2^n)-1.
-- the counter counts up untill he reaches limit_1, then start again. if limit_0 or limit_1 changes - the counter reset.
---------------------------------------------------------
entity counter_nbit is 
	generic(n : integer := 8);
	port	(
				clk,enable,rst : in std_logic;
				limit_0,limit_1	   : in	std_logic_vector (n-1 downto 0);
				q          : out std_logic_vector (n-1 downto 0)
			); 
end counter_nbit;
---------------------------------------------------------
architecture rtl of counter_nbit is
    signal q_int : std_logic_vector (n-1 downto 0):=(others=>'0');
	signal limit_0_prev,limit_1_prev : std_logic_vector(n-1 downto 0);
begin
    process (clk,rst)
    begin
		if (rst='1') then
			q_int <= (others=>'0');
		elsif (rising_edge(clk)) then
				if ((((not(limit_0=limit_0_prev))or(not(limit_1=limit_1_prev))))and((enable='1'))) then
						q_int	<=	(others=>'0');
						limit_0_prev <= limit_0;
						limit_1_prev <= limit_1;
				elsif (q_int(n-1 downto 0) >= limit_1) then
					q_int <= (others=>'0');
				else
					q_int <= q_int + 1;
				end if;
		end if;
    end process;
    q <= q_int(n-1 downto 0); -- Output only 8MSB
end rtl;
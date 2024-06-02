library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
end tb;
---------------------------------------------------------
architecture rtb of tb is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
begin
	L0 : top generic map (8,7,3) port map(rst,ena,clk,x,DetectionCode,detector);
    
	------------ start of stimulus section --------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		ena_p : process
        begin
		  ena <='1';
		  wait;
        end process;
		  
		rst_p : process
        begin
		  rst <='1', '0' after 100 ns;
		  wait;
        end process; 
		
		
		xvec : process
			variable det : integer := 0;
        begin
		  x <= (others => '0');
		  DetectionCode <= det;
		  for i in 0 to 11 loop
			wait for 100 ns;
			x <= x+det+1;
		  end loop;
		  for i in 0 to 11 loop --if the switched diff the right (should be 0)
			wait for 100 ns;
			x <= x-det-1;
		  end loop;
		  for i in 0 to 15 loop
			wait for 100 ns;
			x <= x+det+1;
			if (i = 10) then
				DetectionCode<= det+1;   --change det in the middle of valid sequence
			end if;
		  end loop;
		  DetectionCode<= det;
		  for i in 0 to 15 loop    --change jumps and then det code so they line up
			wait for 100 ns;
			x <= x+det+1;
			if (i = 8) then
				det:= det+1;
			end if;
			if (i = 10) then
				DetectionCode<= det;   
			end if;
		  end loop;
		  wait for 100 ns;    --checks overflow
		  DetectionCode <=0;
		  x <= (n-1 => '0', others =>'1');
		  wait for 100 ns;
		  for i in 0 to 11 loop
		    wait for 100 ns;
			x<=x+1;
	      end loop;
		  
        end process;
		
		
  
end architecture rtb;

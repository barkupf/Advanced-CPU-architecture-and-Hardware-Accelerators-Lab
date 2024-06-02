library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_Logic is
	constant m : integer := 8;
end tb_Logic;

architecture ltb of tb_Logic is
  component Logic is
	GENERIC (	n	: INTEGER := 8);
	PORT 
	(
		X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		sel	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RES	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
  end component;
	SIGNAL X,Y,RES : STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	SIGNAL sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
begin
	L0 : Logic generic map (m) port map(X,Y,sel,RES);
    
	--------- start of stimulus section ------------------	
        tb_sel : process
        begin
			X <= (OTHERS =>'1');
			Y <= (OTHERS => '1');
			sel <= (others => '0'); -- testing not(Y)
			wait for 50 ns; 
			sel <= "001"; -- testing Y or X
			wait for 50 ns; 
			sel <= "010"; -- testing Y and X
			wait for 50 ns; 
			sel <= "011"; -- testing Y xor X
			wait for 50 ns; 
			sel <= "100"; -- testing Y nor X
			wait for 50 ns; 
			sel <= "101"; -- testing Y nand X
			wait for 50 ns;
			sel <= "110"; -- testing not existing enter
			wait for 50 ns; 
			sel <= "111"; -- testing Y xnor X
			wait for 50 ns;           		
		    sel <= "110";  -- change row as you like
		    for i in 0 to 7 loop
			  wait for 50 ns;
			  X <= NOT(X);
			  Y <= X+1;
		    end loop;
		    wait;
        end process tb_sel; 
  
end architecture ltb;

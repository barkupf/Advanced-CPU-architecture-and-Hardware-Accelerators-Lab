LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb IS
	CONSTANT m : integer := 8;--/4,8,16,32
END tb;

ARCHITECTURE Shtb OF tb IS
  COMPONENT Shifter IS
	GENERIC (	n	: INTEGER := 8;
			k	: INTEGER := 3);
  PORT ( X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		 dir	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
         cout	: OUT STD_LOGIC;
         res	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
  END COMPONENT;
  
	SIGNAL cout : STD_LOGIC;
	SIGNAL dir	:	STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL x,y,res : STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	
BEGIN
	L2 : Shifter GENERIC MAP (m) PORT MAP (x,y,dir,cout,res);
    
	--------- start of stimulus section ------------------	
        tb : PROCESS
        BEGIN
		  dir <= "000"; -- "000" -> Shifting left, "001" -> Shifting right 
		  x <= (OTHERS => '0');
		  y <= (1 => '1',OTHERS => '0'); -- for shifting left: y <= (1 => '1',OTHERS => '0');,for shifting right: y <= (m-2 => '1',OTHERS => '0')
		  FOR i in 0 to 17 loop
			wait FOR 50 ns;
			x <= x+1;
		  END loop;
		  wait;
        END PROCESS tb; 
  
END ARCHITECTURE Shtb;

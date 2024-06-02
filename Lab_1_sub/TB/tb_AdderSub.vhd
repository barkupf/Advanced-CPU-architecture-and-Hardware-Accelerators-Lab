LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb IS
	CONSTANT m : integer := 8;--/4,8,16,32
END tb;

ARCHITECTURE AStb OF tb IS
  COMPONENT AdderSub IS
	GENERIC (n : INTEGER := 8);
  PORT 
  (  
	x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	sub_cont : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	res: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	cout: OUT STD_LOGIC
  );
  END COMPONENT;
	SIGNAL cout : STD_LOGIC;
	SIGNAL sub_cont	:	STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL x,y,res : STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	
BEGIN
	L0 : AdderSub GENERIC MAP (m) PORT MAP (x,y,sub_cont,res,cout);
    
	--------- start of stimulus section ------------------	
        tb : PROCESS
        BEGIN
		  sub_cont <= (OTHERS=>'0');
		  x <= (OTHERS => '0');
		  y <= (OTHERS => '1');
		  FOR i in 0 to 17 loop
			wait FOR 50 ns;
			sub_cont <= sub_cont+1;
			x <= x+1;
			y <= y-1;
		  END loop;
		  wait;
        END PROCESS tb; 
  
END ARCHITECTURE AStb;

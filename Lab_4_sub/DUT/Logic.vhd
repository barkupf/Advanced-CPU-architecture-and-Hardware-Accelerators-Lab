LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Logic IS
  GENERIC (	n	: INTEGER := 8);
  PORT 
	(
		X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		sel	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RES	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END Logic;
-------------------------------------
ARCHITECTURE struct OF Logic IS
BEGIN
	WITH sel SELECT
		RES	<=	NOT(Y) WHEN "000",
				Y OR X WHEN "001",
				Y AND X WHEN "010",
				Y XOR X WHEN "011",
				Y NOR X WHEN "100",
				Y NAND X WHEN "101",
				Y XNOR X WHEN "111",
				(OTHERS=>'0') WHEN OTHERS;
END struct;
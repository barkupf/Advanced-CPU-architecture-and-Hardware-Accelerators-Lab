LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
-------------------------------------
ENTITY AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT 
  (  
	x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	sub_cont : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	res: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	cout: OUT STD_LOGIC
  );
END AdderSub;

ARCHITECTURE struct OF AdderSub IS
	COMPONENT FA IS
		PORT (xi, yi, cin: IN STD_LOGIC;
				s, cout: OUT STD_LOGIC);
	END COMPONENT;
	SIGNAL creg,xreg,yreg: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL control: STD_LOGIC;

BEGIN
	define_control : WITH sub_cont SELECT
					 	  control <= '1' WHEN "001",
									 '1' WHEN "010",
									 '0' WHEN OTHERS;
	
	define_yreg :   WITH sub_cont SELECT
						 yreg 	<=	y WHEN "000",
									y WHEN "001",
								    (OTHERS=>'0') WHEN OTHERS;
									
	loading_xreg:	FOR i in 0 to n-1 GENERATE
						WITH sub_cont SELECT
							xreg(i)	<=	(x(i) XOR control) WHEN "000",
										(x(i) XOR control) WHEN "001",
										(x(i) XOR control) WHEN "010",
										'0' WHEN OTHERS;
					END GENERATE loading_xreg;
				
	first : FA PORT MAP(
			xi => xreg(0),
			yi => yreg(0),
			cin => control,
			s => res(0),
			cout => creg(0)
		);
	rest : FOR i in 1 to n-1 GENERATE
		chain : FA PORT MAP(
			xi => xreg(i),
			yi => yreg(i),
			cin => creg(i-1),
			s => res(i),
			cout => creg(i)
		);
	END GENERATE rest;
	
	cout <= creg(n-1);
	
END struct;
library IEEE;
use ieee.std_logic_1164.all;

PACKAGE aux_package IS
--------------------------------------------------------
	COMPONENT top IS
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	END COMPONENT;
---------------------------------------------------------  
	COMPONENT FA IS
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	END COMPONENT;
---------------------------------------------------------	
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
---------------------------------------------------------	
	COMPONENT Shifter IS
	  GENERIC (	n	: INTEGER := 8;
				k	: INTEGER := 3);
	  PORT ( X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 dir	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			 cout	: OUT STD_LOGIC;
			 res	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;
---------------------------------------------------------	
	COMPONENT Logic IS
	  GENERIC (	n	: INTEGER := 8);
	  PORT 
		(
			X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			sel	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			RES	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;
---------------------------------------------------------	
END aux_package;


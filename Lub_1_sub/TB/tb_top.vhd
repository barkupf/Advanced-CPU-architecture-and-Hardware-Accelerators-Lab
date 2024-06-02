LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb IS
	CONSTANT a : integer := 8;--/4,8,16,32
	CONSTANT b : integer := 3;   -- k=log2(n): 2,3,4,5
			-- c : integer := 4	);
END tb;

ARCHITECTURE toptb OF tb IS
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
	  );
  END COMPONENT;
  
	SIGNAL ALUFN : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL Y, X, ALUout : STD_LOGIC_VECTOR (a-1 DOWNTO 0);
	SIGNAL Nflag, Cflag, Zflag, Vflag : STD_LOGIC; 
	
BEGIN
	L3 : top GENERIC MAP (a,b,OPEN) PORT MAP (Y,X,ALUFN,ALUout,Nflag,Cflag,Zflag,Vflag);
    
	--------- start of stimulus section ------------------	
        tb : PROCESS
        BEGIN
		  ALUFN <= "00000";
		  X <= (OTHERS => '0');
		  Y <= (OTHERS => '1');
		  FOR i in 0 to 30 loop
			wait FOR 50 ns;
			ALUFN <= ALUFN+1;
			X <= X+1;
			Y <= Y-1;
		  END loop;
		  wait;
        END PROCESS tb;  
  
END ARCHITECTURE toptb;

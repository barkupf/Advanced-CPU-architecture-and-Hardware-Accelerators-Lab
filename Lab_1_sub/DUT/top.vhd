LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
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
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	SIGNAL 	AdderSub_X, AdderSub_Y, Shifter_X, Shifter_Y, Logic_X, Logic_Y		:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL	AdderSub_RES, Shifter_RES,Logic_RES	:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL 	AdderSub_ALUFN, Shifter_ALUFN, Logic_ALUFN	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL	AdderSub_Carry, Shifter_Cout	:	STD_LOGIC;
	SIGNAL	ZERO, ALUO	: STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS=>'0');
	
	
BEGIN
	int:		AdderSub_X		<=	X_i     			WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0');
				AdderSub_Y		<=	Y_i     			WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0');
				AdderSub_ALUFN	<=	ALUFN_i(2 DOWNTO 0) WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0');
				
				Shifter_X		<=	X_i     			WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0');
				Shifter_Y		<=	Y_i 				WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0');
				Shifter_ALUFN	<=	ALUFN_i(2 DOWNTO 0)	WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0');
				
				Logic_X			<=	X_i 				WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0');
				Logic_Y 		<=	Y_i 				WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0');
				Logic_ALUFN 	<=	ALUFN_i(2 DOWNTO 0) WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0');
			
	------------------------------------------------------------------------------------------------------------------	
	
	AdderSubM:	AdderSub GENERIC MAP (n) PORT MAP (AdderSub_X, AdderSub_Y,AdderSub_ALUFN,AdderSub_RES,AdderSub_Carry);
	ShifterM:	Shifter GENERIC MAP (n,k) PORT MAP (Shifter_X, Shifter_Y, Shifter_ALUFN, Shifter_Cout, Shifter_RES);
	LogicM:		Logic GENERIC MAP (n) PORT MAP (Logic_X, Logic_Y, Logic_ALUFN, Logic_RES);
	
	------------------------------------------------------------------------------------------------------------------	
	output:		WITH ALUFN_i(4 DOWNTO 3) SELECT
					ALUO	<=  AdderSub_RES WHEN "01",
								Shifter_RES WHEN "10",
								Logic_RES WHEN "11",
								(OTHERS=>'0') WHEN OTHERS;
				
	flags:		WITH ALUFN_i SELECT
					Vflag_o	<=	((Y_i(n-1) OR AdderSub_RES(n-1)) AND ((NOT(AdderSub_RES(n-1))) OR (NOT(X_i(n-1)))) AND ((NOT(Y_i(n-1))) OR X_i(n-1)))  WHEN "01000",
								((X_i(n-1) OR Y_i(n-1)) AND (AdderSub_RES(n-1) OR (NOT(X_i(n-1)))) AND ((NOT(AdderSub_RES(n-1))) OR (NOT(Y_i(n-1)))))  WHEN "01001",
								'0' WHEN OTHERS;
				
				Zflag_o	<=	'1' WHEN (ALUO = ZERO) ELSE '0';
				
				WITH ALUFN_i(4 DOWNTO 3) SELECT
					Cflag_o	<=	AdderSub_Carry WHEN "01",
								Shifter_Cout WHEN "10",
								'0' WHEN OTHERS;
				
				Nflag_o <=	'1' WHEN (ALUO(n-1) = '1') ELSE '0';
				
	ALUout_o	<=	ALUO;
				
END struct;


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
		Y_i,X_i			: 	IN 	STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i	 	: 	IN 	STD_LOGIC_VECTOR (4 DOWNTO 0);
		ena,rst,clk	:	IN  STD_LOGIC;
		PWMout		:	OUT	STD_LOGIC;
		ALUout_o	: 	OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		flag_o		: 	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- (Vflag,Zflag,Cflag,Nflag)
  ); 
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	SIGNAL 	AdderSub_X, AdderSub_Y, Shifter_X, Shifter_Y, Logic_X, Logic_Y,PWM_X,PWM_Y		:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL	AdderSub_RES, Shifter_RES,Logic_RES												:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL 	AdderSub_ALUFN, Shifter_ALUFN, Logic_ALUFN,PWM_ALUFN							:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL	AdderSub_Carry, Shifter_Cout													:	STD_LOGIC;
	SIGNAL	PWM_mode,ena_X,ena_Y,ena_ALUFN,PWMout_temp										:	STD_LOGIC;
	SIGNAL	ZERO, ALUO																		: 	STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS=>'0');
	------------------------- for time analizing ------------------------------------------------------------------------------
	SIGNAL	X_reg,Y_reg																		:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL	ALUFN_reg																		:	STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL	flagO_reg																		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	---------------------------------------------------------------------------------------------------------------------------
BEGIN

	AdderSubM:	AdderSub 	GENERIC MAP (n) 	PORT MAP (AdderSub_X, AdderSub_Y,AdderSub_ALUFN,AdderSub_RES,AdderSub_Carry);
	ShifterM:	Shifter 	GENERIC MAP (n,k) 	PORT MAP (Shifter_X, Shifter_Y, Shifter_ALUFN, Shifter_Cout, Shifter_RES);
	LogicM:		Logic 		GENERIC MAP (n) 	PORT MAP (Logic_X, Logic_Y, Logic_ALUFN, Logic_RES);
	PWMM:		PWM			GENERIC MAP (n)		PORT MAP (PWM_Y,PWM_X,ena,rst,clk,PWM_mode,PWMout_temp);
	
	------------------------- enable for time analizing ------------------------------------------------------------------------------
	reg_X:		Reg 		GENERIC MAP(n)		PORT MAP(clk,ena,rst,X_i,X_reg);
	reg_Y:		Reg 		GENERIC MAP(n)		PORT MAP(clk,ena,rst,Y_i,Y_reg);
	reg_ALUFN:	Reg			GENERIC MAP(5)		PORT MAP(clk,ena,rst,ALUFN_i,ALUFN_reg);
	reg_ALUO:	Reg			GENERIC MAP(n)		PORT MAP(clk,ena,rst,ALUO,ALUout_o);
	reg_flag:	Reg			GENERIC MAP(4)		PORT MAP(clk,ena,rst,flagO_reg,flag_o);
	------------------------------------------------------------------------------------------------------------------
	int:		AdderSub_X		<=	X_reg     				WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0'); -- change X_i to X_reg for time analizing
				AdderSub_Y		<=	Y_reg     				WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0'); -- change Y_i to Y_reg for time analizing
				AdderSub_ALUFN	<=	ALUFN_reg(2 DOWNTO 0) 	WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE (OTHERS=>'0'); -- change ALUFN_i to ALUFN_reg for time analizing
				
				Shifter_X		<=	X_reg     				WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0'); -- change X_i to X_reg for time analizing
				Shifter_Y		<=	Y_reg					WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0'); -- change Y_i to Y_reg for time analizing
				Shifter_ALUFN	<=	ALUFN_reg(2 DOWNTO 0)	WHEN ALUFN_i(4 DOWNTO 3) = "10" ELSE (OTHERS=>'0'); -- change ALUFN_i to ALUFN_reg for time analizing
				
				Logic_X			<=	X_reg					WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0'); -- change X_i to X_reg for time analizing
				Logic_Y 		<=	Y_reg 					WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0'); -- change Y_i to Y_reg for time analizing
				Logic_ALUFN 	<=	ALUFN_reg(2 DOWNTO 0) 	WHEN ALUFN_i(4 DOWNTO 3) = "11" ELSE (OTHERS=>'0'); -- change ALUFN_i to ALUFN_reg for time analizing
			
				PWM_X			<=	X_i						WHEN ALUFN_i(4 DOWNTO 3) = "00"	ELSE (OTHERS=>'0'); -- DO NOT change when time analizing
				PWM_Y			<=	Y_i						WHEN ALUFN_i(4 DOWNTO 3) = "00" ELSE (OTHERS=>'0'); -- DO NOT change when time analizing
				PWM_mode		<=	ALUFN_i(0)				WHEN ALUFN_i(4 DOWNTO 3) = "00" ELSE '0';			-- DO NOT change when time analizing
	------------------------------------------------------------------------------------------------------------------		
	output:		WITH ALUFN_i(4 DOWNTO 3) SELECT
					ALUO	<=  AdderSub_RES WHEN "01",
								Shifter_RES WHEN "10",
								Logic_RES WHEN "11",
								(OTHERS=>'0') WHEN OTHERS;
								
				PWMout <= PWMout_temp WHEN (ALUFN_i(4 DOWNTO 3)) = "00" ELSE '0'; -- we defined the PWM output to be '0' if not active (ALUFN_i(4 DOWNTO 3) is not "00")
				
	flags:		WITH ALUFN_i SELECT
					flagO_reg(3)	<=	((Y_i(n-1) OR AdderSub_RES(n-1)) AND ((NOT(AdderSub_RES(n-1))) OR (NOT(X_i(n-1)))) AND ((NOT(Y_i(n-1))) OR X_i(n-1)))  WHEN "01000",
									((X_i(n-1) OR Y_i(n-1)) AND (AdderSub_RES(n-1) OR (NOT(X_i(n-1)))) AND ((NOT(AdderSub_RES(n-1))) OR (NOT(Y_i(n-1)))))  WHEN "01001",
									'0' WHEN OTHERS; -- change flag_o to flagO_reg when time analizing
				
				flagO_reg(2)	<=	'1' WHEN (ALUO = ZERO) ELSE '0'; -- change flag_o to flagO_reg when time analizing
				
				WITH ALUFN_i(4 DOWNTO 3) SELECT
					flagO_reg(1)	<=	AdderSub_Carry WHEN "01",
									Shifter_Cout WHEN "10",
									'0' WHEN OTHERS; -- change flag_o to flagO_reg when time analizing
				
				flagO_reg(0)	<=	'1' WHEN (ALUO(n-1) = '1') ELSE '0'; -- change flag_o to flagO_reg when time analizing
				
--	ALUout_o	<=	ALUO; -- disable when time analizing
				
END struct;


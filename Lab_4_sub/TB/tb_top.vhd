LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY tb IS
	CONSTANT a : integer := 8;-- n = 4,8,16,32
	CONSTANT b : integer := 3;-- k = log2(n): 2,3,4,5
	CONSTANT c : integer := 4;-- m = 2^(k-1)
END tb;

ARCHITECTURE toptb OF tb IS
  
	signal	Y,X			: 	STD_LOGIC_VECTOR (a-1 DOWNTO 0);
	signal	ALUFN	 	: 	STD_LOGIC_VECTOR (4 DOWNTO 0);
	signal	ena,rst,clk	:	STD_LOGIC;
	signal	PWMout		:	STD_LOGIC;
	signal	ALUout_o	: 	STD_LOGIC_VECTOR(a-1 DOWNTO 0);
	signal	flag_o		: 	STD_LOGIC_VECTOR(3 DOWNTO 0); -- (Vflag,Zflag,Cflag,Nflag)
	
BEGIN
	---------------------------------------------------------------------------------							
	L0 : top GENERIC MAP (a,b,c) PORT MAP (Y,X,ALUFN,ena,rst,clk,PWMout,ALUout_o,flag_o);
	---------------------------------------------------------------------------------							
    -------------------- start of stimulus section ----------------------------------
	---------------------------------------------------------------------------------							
	--------------------------- reset -----------------------------------------------
	intrst: 	PROCESS
				BEGIN
					rst <= '1','0' after 128 us;
					wait;
				END process;
	---------------------------------------------------------------------------------
	-------------------------- enabel -----------------------------------------------
	intenable:	PROCESS
				BEGIN
					ena <= '0','1' after 196 us;
					wait;
				END process;
	---------------------------------------------------------------------------------
	------------------------- clock -------------------------------------------------
	-- we know the frequancy of the clock is going to be 31.25 KHz
	-- so the time period of the clock is 32 us => 16 us for set and 16 us for reset
	-- for time analizing we will use a clock with frequancy of 50 MHz => time period of 20 ns
	---------------------------------------------------------------------------------
	intclock:	PROCESS
				BEGIN
					clk <= '0';
					wait for 16 us; -- for time analizing 10 ns
					clk <= not clk;
					wait for 16 us; -- for time analizing 10 ns
				END PROCESS;
	---------------------------------------------------------------------------------
	------------------------- test bench --------------------------------------------
	tb: 		PROCESS
				BEGIN
					ALUFN <= "00000","00001" after 392 us;
					X <= (2=>'1',OTHERS => '0');
					Y <= (3=>'1',OTHERS => '0');
					wait for 608 us;
					FOR i in 0 to 100 loop
						wait FOR 16 us;
						ALUFN <= ALUFN+1;
						X <= X+1;
						Y <= Y-1;
					END loop;
					wait;
				END PROCESS;
					
	---------------------------------------------------------------------------------
END toptb;

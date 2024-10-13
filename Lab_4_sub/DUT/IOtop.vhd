LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY IOtop IS
  GENERIC (line_num : INTEGER := 7;
		   n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
		clk  : in std_logic;
		SW_i : in std_logic_vector(n-1 downto 0); -- Switch Port
		SW_8 : in std_logic; -- enabel
		KEY0, KEY1, KEY2,KEY3 : in std_logic; -- Keys Ports (KEY3=rst)
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(line_num-1 downto 0); -- 7 segment Ports
		LEDs : out std_logic_vector(9 downto 0); -- Leds Port
		GPIO_9 : out std_logic -- PWMout
  ); 
END IOtop;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF IOtop IS 
	-- top Inputs
	signal ALUout_o, X, Y 	 		 : std_logic_vector(n-1 downto 0);
	signal flag_o					 : std_logic_vector(3 DOWNTO 0);
	signal ALUFN 					 : std_logic_vector(4 downto 0);
	signal rst,PLLOFclk,ena,PWMout	 : std_logic;
	
BEGIN
	
	topM:	top generic map(n,k,m) port map(Y,X,ALUFN,ena,rst,PLLOFclk,PWMout,ALUout_o,flag_o);
	
	--------------------- set Clock ----------------------------
	clock:	CounterEnvelope port map(clk,ena,rst,PLLOFclk);
	
	--------------------- set segments ----------------------------
	-- Display X
	Decoder_X_Hex0: 		DecoderHEX	port map(X(3 downto 0) , HEX0);
	Decoder_X_Hex1: 		DecoderHEX	port map(X(7 downto 4) , HEX1);
	-- Display Y 
	Decoder_Y_Hex2: 		DecoderHEX	port map(Y(3 downto 0) , HEX2);
	Decoder_Y_Hex3: 		DecoderHEX	port map(Y(7 downto 4) , HEX3);
	-- Display ALU output
	Decoder_ALUOut_Hex4: 	DecoderHEX	port map(ALUout_o(3 downto 0) , HEX4);
	Decoder_ALUOut_Hex5: 	DecoderHEX	port map(ALUout_o(7 downto 4) , HEX5);
	
	--------------------- set LEDs ----------------------------
	LEDs(9 downto 5) <= ALUFN;
	LEDs(3 downto 0) <= flag_o; -- (Vflag,Zflag,Cflag,Nflag)
	
	-------------- set Keys, Switch & GPIO --------------------
	process(KEY0, KEY1, KEY2) 
	begin
--		if rising_edge(PLLOFclk) then
			if KEY0 = '0' then
				Y     <= SW_i;
			elsif KEY1 = '0' then
				ALUFN <= SW_i(4 downto 0);
			elsif KEY2 = '0' then
				X	  <= SW_i;
			end if;
--		end if;
	end process;
	
	rst <= not(KEY3);
	ena <= SW_8;
	GPIO_9 <= PWMout;
	
END struct;


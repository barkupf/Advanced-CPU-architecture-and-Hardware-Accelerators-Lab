library IEEE;
use ieee.std_logic_1164.all;

PACKAGE aux_package IS
--------------------------------------------------------
	COMPONENT top IS
		GENERIC (	n : INTEGER := 8;
					k : integer := 3;   -- k=log2(n)
					m : integer := 4	-- m=2^(k-1)
				);
		PORT 
		(  
			Y_i,X_i			: 	IN 	STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN_i	 	: 	IN 	STD_LOGIC_VECTOR (4 DOWNTO 0);
			ena,rst,clk	:	IN  STD_LOGIC;
			PWMout		:	OUT	STD_LOGIC;
			ALUout_o	: 	OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			flag_o		: 	OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- (Vflag,Zflag,Cflag,Nflag)
		); 
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
	COMPONENT counter_nbit IS
	generic(n : integer := 8);
	port	(
				clk,enable,rst : in std_logic;
				limit_0,limit_1	   : in	std_logic_vector (n-1 downto 0);
				q          : out std_logic_vector (n-1 downto 0)
			); 
	END COMPONENT counter_nbit;
---------------------------------------------------------
	COMPONENT PWM is
    generic (  n : integer := 8);
    port 
    (  
			Y_i,X_i					: 	in std_logic_vector (n-1 downto 0);
			ena,rst,clk,PWM_mode	:	in	std_logic;
			PWM_out					:	out	std_logic
		
    );
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Reg is
	generic( Dwidth: integer:=16);
	port(	clk,Ein,rst: in std_logic;	
			Rin  : in std_logic_vector(Dwidth-1 downto 0);
			Rout  : out std_logic_vector(Dwidth-1 downto 0)
	);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT DecoderHEX IS
	  GENERIC (	n			: INTEGER := 4;
				Size	: integer := 7);
	  PORT (data		: in STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			num   		: out STD_LOGIC_VECTOR (Size-1 downto 0));
	END COMPONENT;
---------------------------------------------------------
	COMPONENT IOtop IS
		GENERIC (line_num : INTEGER := 7;
			   n : INTEGER := 8;
			   k : integer := 3;   -- k=log2(n)
			   m : integer := 4	); -- m=2^(k-1)
		PORT 
		(	  
			clk  : in std_logic; -- for single tap
			SW_i : in std_logic_vector(n-1 downto 0); -- Switch Port
			SW_8 : in std_logic; -- enabel
			KEY0, KEY1, KEY2,KEY3 : in std_logic; -- Keys Ports
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(line_num-1 downto 0); -- 7 segment Ports
			LEDs : out std_logic_vector(9 downto 0); -- Leds Port
			GPIO_9 : out std_logic -- PWMout
		);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT PLL PORT(
			  areset		: IN STD_LOGIC  := '0';
			   inclk0		: IN STD_LOGIC  := '0';
				   c0		: OUT STD_LOGIC ;
				locked		: OUT STD_LOGIC );
		END COMPONENT;
---------------------------------------------------------
	COMPONENT CounterEnvelope is port (
		Clk,En,rst : in std_logic;	
		Qout       : out std_logic); 
	END COMPONENT;
---------------------------------------------------------
	COMPONENT counteroverflow6 PORT(
	      clk,enable,rst : IN STD_LOGIC;	
	      q          	 : OUT STD_LOGIC);
    END COMPONENT;
---------------------------------------------------------
END aux_package;


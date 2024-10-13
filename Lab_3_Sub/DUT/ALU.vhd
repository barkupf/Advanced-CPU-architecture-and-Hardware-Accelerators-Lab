LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY ALU IS
  GENERIC (length : INTEGER := 16);
  PORT ( A, B: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         OPC: IN STD_LOGIC_VECTOR (3 downto 0);
         C: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
         Cflag, Zflag, Nflag: OUT STD_LOGIC := '0'  --check flag reset between 
		);
END ALU;
--------------------------------------------------------
ARCHITECTURE rtl OF ALU IS
component AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT 
  (  
	x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	sub_cont : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	res: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	cout: OUT STD_LOGIC
  );
END component;
signal adder_res : std_logic_vector(length-1 downto 0);
signal adder_c : STD_LOGIC;
signal Cin : STD_LOGIC;
signal Cout : std_logic;
signal alu_out: std_logic_vector(length-1 downto 0);
constant zeros : std_logic_vector(length-1 downto 0) := (others => '0');
BEGIN
adersub:	AdderSub generic map (length) port map (B,A,OPC(2 downto 0),adder_res,adder_c);
	with OPC select
		alu_out <= adder_res when "0000",
			adder_res  when "0001",
			A and B    when "0010",
			A or B     when "0011",
			A xor B    when "0100",
			unaffected when others; -- was 0000 when others
	with OPC select		
		Cflag <= adder_c when "0000",
				 adder_c  when "0001",
				 unaffected when others;   --was 0 when others
	Zflag <= '1' when (alu_out = zeros) else '0';
	Nflag<= '1' when (alu_out(length-1) = '1') else '0';
	c <= alu_out;
	
END rtl;


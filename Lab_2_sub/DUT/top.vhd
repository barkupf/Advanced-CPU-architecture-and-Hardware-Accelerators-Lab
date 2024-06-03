LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
		signal x_j1,x_j2 : std_logic_vector(n-1 downto 0);
		signal valid : integer;
		signal DetectionCode_vec : std_logic_vector(n-1 downto 0);
		signal adder_res : std_logic_vector(n-1 downto 0);
		signal cout : std_logic;
begin
		DetectionCode_vec <= (0=>'1', others=>'0') when DetectionCode = 0 else
							 (1=>'1', others=>'0') when DetectionCode = 1 else
							 (0=>'1',1=>'1', others=>'0') when DetectionCode = 2 else
							 (2=>'1', others=>'0') when DetectionCode = 3 else
							 (others=>'0');
pros_1:	process (rst,ena,clk)
		begin
			if (rst='1') then
				x_j1 <= (others=>'0');
				x_j2 <= (others=>'0');
			elsif (clk'event and clk='1') then
				if (ena='1') then
					x_j2 <= x_j1;
					x_j1 <= x;
				end if;
			end if;
		end process;
		
ader_con:	Adder generic map (n) port map (x_j2,DetectionCode_vec,'0',adder_res,cout);

pros_2:	process (adder_res, DetectionCode)
		begin
			if (x_j1=adder_res and cout='0') then
				valid <= 1;
			else
				valid <= 0;
			end if;
		end process;
			
pros_3:	process(clk,rst,ena,valid) --
			variable counter : integer;
			variable det : std_logic;
			variable m_c : integer;
		begin
			m_c := m-1;
			if (rst='1') then
				det := '0';
				counter := 0;
			elsif (clk'event and clk='1') then
				if (ena='1') then
					if (valid = 0) then
						counter := 0;
						det := '0';
					elsif (counter < m_c and valid = 1) then
						counter := counter + 1;
						det := '0';
					else
						det := '1';
					end if;
				else
				end if;
			end if;
			detector <= det;
		end process;
		
		
						
	
	
end arc_sys;








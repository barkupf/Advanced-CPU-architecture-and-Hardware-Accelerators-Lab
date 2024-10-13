library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------
-- Master Slave register:
-- on rising edge the Master register updates to the value of the input, 
-- and the output updated to the value of the Slave register.
-- on falling edge the Slave register updates to the value of the Master register.
-----------------------------------
entity MSReg is
generic( Dwidth: integer:=16);
port(	clk,Enin,rst: in std_logic;	
		RegIn  : in std_logic_vector(Dwidth-1 downto 0);
		RegOut  : out std_logic_vector(Dwidth-1 downto 0)
);
end MSReg;  
--------------------------------------------------------------
architecture behav of MSReg is
signal MasterReg,SlaveReg : std_logic_vector(Dwidth-1 downto 0);
begin
Master:		process(clk,rst)
			begin
				if (rst = '1') then
					MasterReg <= (others => '0'); -- if rst is on, reset the Master register
				elsif (clk'event and clk='1') then -- Master register updates on falling edge if enable is on
					if (Enin='1') then
						MasterReg <= RegIn;
					end if;
				end if;
			end process;

Slave:		process(clk,rst)
			begin
				if (rst = '1') then
					SlaveReg <= (others => '0'); -- if rst is on, reset the Slave register
				elsif (clk'event and clk='0') then -- Slave register updates on falling edge
					SlaveReg <= MasterReg;
				end if;
			end process;
			
			RegOut <= SlaveReg;	-- output of the register
	
end behav;
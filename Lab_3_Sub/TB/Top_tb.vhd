library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
use work.aux_package.all;
----------------------------------------------------------------------------------
-- This test bench check the folowing Instruction:
----------------------------------------------------------------------------------
--	   1. mov 	R1,16 		= 0xC110	(R1=16)
--	   2. mov 	R2,17		= 0xC211	(R2=17)
--	   3. ld	R3,0(R0)	= 0xD300	(R3=1)
--	   4. ld	R4,0(R1)	= 0xD410	(R4=0xF0F0)
--	   5. ld	R5,1(R1)	= 0xD511	(R5=0xFFFF)
--	   6. st  	R1,0(R1) 	= 0xE110	(store in addres 16)
--	   7. st	R2,0(R2)	= 0xE220	(store in addres 17)
--	   8. add	R1,R3,R1	= 0x0131	(R1=17)
--	   9. sub	R1,R2,R1	= 0x1121	(R1=0)
--	  10. st	R1,1(R2)	= 0xE121	(store in addres 18)
--	  11. and	R6,R5,R4	= 0x2654	(expecting: 0xF0F0)
--	  12. or	R7,R5,R4	= 0x3754	(expecting: 0xFFFF)
--    13. xor	R8,R5,R4	= 0x4854	(expecting: 0x0F0F)	
--	  14. st	R6,2(R2)	= 0xE622	(store in addres 19)
--    15. st	R7,3(R2)	= 0xE723	(store in addres 20)
--	  16. st	R8,4(R2)	= 0xE824	(store in addres 21)
--    17. done				= 0xF000	(exiting)	
----------------------------------------------------------------------------------			
entity Top_tb is
generic( Dwidth: 		integer:=16;
		 Awidth: 		integer:=6;
		 RFAwidth: 		integer:=4;
		 Opsize:		integer:=4;
		 m:		 		integer:=16;  -- Program Memory In Data Size
		 dept:    		integer:=64 -- Program Memory Size
);
	constant DataMem_result:	 	string(1 to 68) :=
	"C:\Bar\BGU\2023-24\semester B\CPU LAB\L3\TB\DTCMcontent_Datapath.txt";
	
	constant DataMem_location: 	string(1 to 65) :=
	"C:\Bar\BGU\2023-24\semester B\CPU LAB\L3\TB\DTCMinit_Datapath.txt";
	
	constant ProgMem_location: 	string(1 to 65) :=
	"C:\Bar\BGU\2023-24\semester B\CPU LAB\L3\TB\ITCMinit_Datapath.txt";
end Top_tb;  
--------------------------------------------------------------
architecture behav of Top_tb is

------------------------- Signals -------------------------------------
signal	FSM_done: std_logic;
signal	clk, rst, ena, TBactive, TBProgmem_wren, TBDatamem_wren  : STD_LOGIC;
signal	TBProgmem_datain  : std_logic_vector(m-1 downto 0);  --TB Program input
signal	TBDatamem_datain  : std_logic_vector(Dwidth-1 downto 0);  -- TB Memory input
signal	TBDatamem_dataout : std_logic_vector(Dwidth-1 downto 0); -- TB Memory result 
signal	TBProgmem_writeaddr, TBDatamem_writeaddr, TBDatamem_readaddr :	std_logic_vector(Awidth-1 downto 0); -- TB write/read addres of  Program/Data Memory
signal	ProgMemIn_done,	DataMemIn_done	:	boolean;
					
begin

------------------------- Conecting to Top -------------------------------------
Unit_Top:	top port map(clk, rst, ena,FSM_done,TBProgmem_datain,TBDatamem_datain,TBDatamem_dataout,TBactive,
							TBProgmem_wren,TBDatamem_wren,TBProgmem_writeaddr,TBDatamem_writeaddr,TBDatamem_readaddr);

------------------------- Simulation -------------------------------------
							
---------- Set Clock ---------------
gen_clk	: 	process
			begin
			  clk <= '0';
			  wait for 50 ns;
			  clk <= not clk;
			  wait for 50 ns;
			end process;
------------ RST -------------			
gen_rst:	process
			begin
				rst <= '1','0' after 100 ns;
				wait;
			end process;
			
------------ Active TB -------------
gen_TB:		process
			begin
				TBactive <= '1';
				wait until ProgMemIn_done and DataMemIn_done;
				TBactive <= '0';
				wait until FSM_done = '1';
				TBactive <= '1';
			end process;

------------ Load TB to Memory (Data and Program) -------------
Data_load:		process
					file		DataMemIn_file	:	text open read_mode	is	DataMem_location;
					variable	L				:	line;
					variable	good			:	boolean;
					variable	memline			:	std_logic_vector(Dwidth-1 downto 0);
					variable	currAddres		:	std_logic_vector(Awidth-1 downto 0);
				begin
					DataMemIn_done	<=	false;
					currAddres	:=	(others=>'0');
					while not endfile(DataMemIn_file) loop
						readline(DataMemIn_file,L);
						hread(L,memline,good);
						next when not good;
						TBDatamem_wren <= '1';
						TBDatamem_writeaddr <= currAddres;
						TBDatamem_datain <= memline;
						wait until rising_edge(clk);
						currAddres := currAddres+1;
					end loop;
					TBDatamem_wren <= '0';
					DataMemIn_done <= true;
					file_close(DataMemIn_file);
					wait;
				end process;
			
Program_load:	process
					file		ProgMemIn_file	:	text open read_mode	is	ProgMem_location;
					variable	L				:	line;
					variable	good			:	boolean;
					variable	memline			:	std_logic_vector(Dwidth-1 downto 0);
					variable	currAddres		:	std_logic_vector(Awidth-1 downto 0);
				begin
					ProgMemIn_done	<=	false;
					currAddres	:=	(others=>'0');
					while not endfile(ProgMemIn_file) loop
						readline(ProgMemIn_file,L);
						hread(L,memline,good);
						next when not good;
						TBProgmem_wren <= '1';
						TBProgmem_writeaddr <= currAddres;
						TBProgmem_datain <= memline;
						wait until rising_edge(clk);
						currAddres := currAddres+1;
					end loop;
					TBProgmem_wren <= '0';
					ProgMemIn_done <= true;
					file_close(ProgMemIn_file);
					wait;
				end process;
				
				ena	<=	'1'	when	(DataMemIn_done And ProgMemIn_done)	else	'0';

------------------------- Getting results -------------------------------------
			
Get_Memory: process
				file		DataMemOut_file	:	text open write_mode is DataMem_result;
				variable	L				:	line;
				variable	good			:	boolean;
				variable	memline			:	std_logic_vector(Dwidth-1 downto 0);
				variable	currAddres		:	std_logic_vector(Awidth-1 downto 0);
				variable	counter			:	integer;
			begin
				wait until FSM_done='1';
				currAddres := (others=>'0');
				counter	   := 1;
				while counter < dept loop  -- the Memory size is "dept" lines
					TBDatamem_readaddr	<=	currAddres;
					wait until rising_edge(clk);
					wait until rising_edge(clk);
					memline := TBDatamem_dataout;
					hwrite(L,memline);
					writeline(DataMemOut_file,L);
					currAddres := currAddres+1;
					counter := counter+1;
				end loop;
				file_close(DataMemOut_file);
				wait;
			end process;
end behav;
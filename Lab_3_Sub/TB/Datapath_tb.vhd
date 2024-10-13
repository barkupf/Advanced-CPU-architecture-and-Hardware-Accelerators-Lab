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
entity Datapath_tb is
generic( Dwidth: 		integer:=16;
		 Awidth: 		integer:=6;
		 RFAwidth: 		integer:=4;
		 Opsize:		integer:=4;
		 m:		 		integer:=16;  -- Program Memory In Data Size
		 dept:    		integer:=64; -- Program Memory Size
		 ImWidth: 		integer := 8;
		 offset_size: 	integer:=8
);
	constant DataMem_result:	 	string(1 to 64) :=
	"C:\Users\barku\OneDrive\Documents\LAB 3\DTCMcontent_Datapath.txt";
	
	constant DataMem_location: 	string(1 to 61) :=
	"C:\Users\barku\OneDrive\Documents\LAB 3\DTCMinit_Datapath.txt";
	
	constant ProgMem_location: 	string(1 to 61) :=
	"C:\Users\barku\OneDrive\Documents\LAB 3\ITCMinit_Datapath.txt";
end Datapath_tb;  
--------------------------------------------------------------
architecture behav of Datapath_tb is

------------------------- Signals -------------------------------------
signal	Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in: std_logic;
signal	OPC : std_logic_vector(3 downto 0);
signal	PCsel,RFaddr : std_logic_vector(1 downto 0);
signal	clk,TBactive,rst:  std_logic;
signal	TBProgmem_wren,TBDatamem_wren:  std_logic;
signal	TBProgmem_datain: std_logic_vector(m-1 downto 0);
signal	TBDatamem_datain: std_logic_vector(Dwidth-1 downto 0);
signal	TBProgmem_writeaddr,TBDatamem_writeaddr,TBDatamem_readaddr:  std_logic_vector(Awidth-1 downto 0);
signal	TBDatamem_dataout:  std_logic_vector(Dwidth-1 downto 0);
signal	add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done,Zflag,Cflag,Nflag: std_logic;

signal	ProgMemIn_done,DataMemIn_done: boolean:=false;
signal	FSM_done: std_logic:='0';
					
begin

------------------------- Conecting to Datapath -------------------------------------
Unit_Datapath:	Datapath generic map(Dwidth,Awidth,RFAwidth,Opsize,m,dept,offset_size)	port map(Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,
																								OPC,PCsel,RFaddr,clk,TBactive,rst,TBProgmem_wren,TBDatamem_wren,
																								TBProgmem_datain,TBDatamem_datain,TBProgmem_writeaddr,
																								TBDatamem_writeaddr,TBDatamem_readaddr,
																								add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done,Zflag,Cflag,Nflag,TBDatamem_dataout);
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
				rst <= '1','0' after 100 ns; --'1','0' after 50 ns;
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


------------ Start the test bench -------------

TB_start:	process
			begin
			------------------------------------------------------------
				wait until ProgMemIn_done and DataMemIn_done;
			-- reset
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	-- ALU output unefected
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; -- RFaddr unefected
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"10"; -- zero input to PC
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0'; 
			------------------------------------------------------------
			-- Mov Instraction = 0xC110 = R[1]<=16
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0'; 
			
			-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'1';
				Imm2_in	<=	'0';
				FSM_done<=	'0'; 				
			------------------------------------------------------------
			-- Move Instraction = 0xC211 = R[2] <= 17
			------------------------------------------------------------
				-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0'; 
			
			-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'1';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			------------------------------------------------------------
			-- Load Instraction = 0xD300 = R[3] <= Mem[0] = 1
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- C <= A (=R[1])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
			-- get Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			--  R[3] <= Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'1';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00"; --R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			------------------------------------------------------------
			-- Load Instraction = 0xD410 = R[4] <= Mem[R[1]+0] = Mem[16] = 0xF0F0
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- C <= A (=R[1])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
			-- get Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			--  R[4] <= Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'1';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00"; --R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			------------------------------------------------------------
			-- Load Instraction = 0xD511 = R[5] <= Mem[R[1]+1] = Mem[17] = 0xFFFF
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- C <= A (=R[1])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
			-- get Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			--  R[5] <= Mem[C]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'1';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00"; --R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			------------------------------------------------------------
			-- Store Instraction = 0xE110 = Mem[R[1]+0]=M[16]<=R[1]=16
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[1])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[1] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			------------------------------------------------------------
			-- Store Instraction = 0xE220 = Mem[R[2]+0]=M[17]<=R[2]=17
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[2])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[2] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
	
			------------------------------------------------------------
			-- Add Instraction:  R1 <= R3 + R1	= 0x0131
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			-- C <= A + B = R[b] + R[c]
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"10";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- R[a] <= C
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00";
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			------------------------------------------------------------
			-- Sub Instraction:  R1 <= R2 - R1	= 0x1121
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			-- C <= A - B = R[b] - R[c]
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0001";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"10";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- R[a] <= C
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00";
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';

			------------------------------------------------------------
			-- Store Instraction = 0xE121 = Mem[R[2]+1]= M[18] <= R[1] = 0
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[2])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[2] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			------------------------------------------------------------
			-- And Instraction:  R6 <= R5 and R4	= 0x2654
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			-- C <= A and B = R[b] and R[c]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0010";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"10";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- R[a] <= C
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00";
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';

			------------------------------------------------------------
			-- Or Instraction:  R7 <= R5 or R4	= 0x3754
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			-- C <= A and B = R[b] or R[c]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0011";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"10";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- R[a] <= C
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00";
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			------------------------------------------------------------
			-- Xor Instraction:  R8 <= R5 xor R4	= 0x4854
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			-- C <= A and B = R[b] xor R[c]
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0100";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"10";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
			-- R[a] <= C
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'1';
				RFout	<=	'0';
				RFaddr	<=	"00";
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00"; 
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
							
			------------------------------------------------------------
			-- Store Instraction = 0xE622 = Mem[R[2]+2]= M[19] <= R[6]
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[2])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[6] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			------------------------------------------------------------
			-- Store Instraction = 0xE723 = Mem[R[2]+3]= M[20] <= R[7]
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[2])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[7] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			------------------------------------------------------------
			-- Store Instraction = 0xE824 = Mem[R[2]+4]= M[21] <= R[8]
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1'; -- A<=R[b]
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'1';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"01"; -- R[b]
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- C <= A (=R[2])+Immidiate 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'1';
				OPC		<=	"0000";	-- ALU output =  A (=R[b])+Immidiate
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'1';
				FSM_done<=	'0';
				
				-- Memory Addres <= C 
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'1';
				Cout	<=	'1';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Mem[Memory Addres] <= R[8] 
				wait until clk'event and clk='1'; 
				Mem_wr	<=	'1';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'1';
				RFaddr	<=	"00"; -- R[a]
				IRin	<=	'0';
				PCin	<=	'1';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
			
			------------------------------------------------------------
			-- Done Instraction: 0xF000
			------------------------------------------------------------
			-- Fetch
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";  
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11"; 
				IRin	<=	'1';
				PCin	<=	'0';
				PCsel	<=	"00";
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'0';
				
				-- Decode
				wait until clk'event and clk='1';
				Mem_wr	<=	'0';
				Mem_out	<=	'0';
				Mem_in	<=	'0';
				Cout	<=	'0';
				Cin		<=	'0';
				OPC		<=	"1111";	
				Ain		<=	'0';
				RFin	<=	'0';
				RFout	<=	'0';
				RFaddr	<=	"11";
				IRin	<=	'0';
				PCin	<=	'0';
				PCsel	<=	"10"; -- reset PC
				Imm1_in	<=	'0';
				Imm2_in	<=	'0';
				FSM_done<=	'1';
			
			end process;

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
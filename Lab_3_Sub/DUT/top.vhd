library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;
---------------------------------------------------------------------------------
ENTITY top IS
	generic( n: integer:=16;		-- Data Memory TB data width
			 m: 	  integer:=16;  -- Program Memory TB data width
			 Awidth:  integer:=6;	-- TB Address width
			 OpCodewidth:  integer:=4);  -- opcode size
	PORT(
		clk, rst, ena  : in STD_LOGIC;
		FSM_done : out std_logic;	
		
		-- Test Bench
		TBProgmem_datain  : in std_logic_vector(m-1 downto 0);  --TB Program input
		TBDatamem_datain  : in std_logic_vector(n-1 downto 0);  -- TB Memory input
		TBDatamem_dataout : out std_logic_vector(n-1 downto 0); -- TB Memory result
		TBactive	   : in std_logic; -- TB activation 
		TBProgmem_wren, TBDatamem_wren : in std_logic; -- write enable 
		TBProgmem_writeaddr, TBDatamem_writeaddr, TBDatamem_readaddr :	in std_logic_vector(Awidth-1 downto 0) -- TB write/read addres of  Program/Data Memory
	);
END top;
---------------------------------------------------------------
ARCHITECTURE arch OF top IS
signal add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done	: std_logic;  --operations
signal Nflag,Zflag, Cflag: std_logic;                                --flags
signal mem_in, mem_wr, mem_out, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in: std_logic;    --enables
signal RFaddr, PCsel: std_logic_vector(1 downto 0); -- RF and PC selectors
signal OPC: std_logic_vector(OpCodewidth-1 downto 0);  --ALU opcode
begin
Control_unit: control	 port map (clk, rst,ena,add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done, Nflag,Zflag, Cflag, 
						mem_in, mem_wr,  mem_out, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in, FSM_done,
						RFaddr, PCsel, OPC
						);
DataPath_unit: Datapath port map(mem_wr,mem_out,mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,	
												OPC,PCsel,RFaddr,clk,TBactive,rst,TBProgmem_wren,TBDatamem_wren,
												TBProgmem_datain,TBDatamem_datain,TBProgmem_writeaddr,TBDatamem_writeaddr,TBDatamem_readaddr,
												add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done,Zflag,Cflag,Nflag,TBDatamem_dataout
												);


end arch;

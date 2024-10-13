library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-----------------------------------
-- Connecting all the Modules to the Bus (or to each other if needed to).
-- Connecting the test benches to the Memory (Data and Program).
-- Connecting the Control unit signals to the Modules. 
-----------------------------------
entity Datapath is
generic( Dwidth: 		integer:=16;
		 Awidth: 		integer:=6;
		 RFAwidth: 		integer:=4;
		 Opsize:		integer:=4;
		 m:		 		integer:=16;  -- Program Memory In Data Size
		 dept:    		integer:=64; -- Program Memory Size
		 ImWidth: 		integer := 8;
		 offset_size: 	integer:=8
		);
port(	 -- Control signals--
		Mem_wr,Mem_out,Mem_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in: in std_logic;	
		OPC : in std_logic_vector(3 downto 0);
		PCsel,RFaddr: in std_logic_vector(1 downto 0);
		-- TB signals --
		clk,TBactive,rst: in std_logic;
		TBProgmem_wren,TBDatamem_wren: in std_logic;
		TBProgmem_datain,TBDatamem_datain: in std_logic_vector(Dwidth-1 downto 0);
		TBProgmem_writeaddr,TBDatamem_writeaddr,TBDatamem_readaddr: in std_logic_vector(Awidth-1 downto 0);
		--Status signals --
		add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done,Zflag,Cflag,Nflag: out std_logic; 
		-- Output --
		TBDatamem_dataout: out std_logic_vector(Dwidth-1 downto 0)
);
end Datapath;  
--------------------------------------------------------------
architecture behav of Datapath is
------------ defining signals ------------
-- ALU --
signal A,B,CRegin : std_logic_vector(Dwidth-1 downto 0);
signal CRegout	  : std_logic_vector(Dwidth-1 downto 0);

-- Register File --
signal WR_RegAddr : std_logic_vector(RFAwidth-1 downto 0);
signal W_RegData,RFData : std_logic_vector(Dwidth-1 downto 0);

-- IR --
signal	Opcode	  : std_logic_vector(Opsize-1 downto 0);
--signal	RWregAddr : std_logic_vector(RFAwidth-1 downto 0);
signal  offset	  : std_logic_vector(offset_size-1 downto 0);
signal	IR_imm	  : std_logic_vector(ImWidth-1 downto 0);

-- Pogram Memory --
signal Pogram_Raddr : std_logic_vector(Awidth-1 downto 0);
signal Pogram_DataOut : std_logic_vector(Dwidth-1 downto 0);

-- Data Memory --
signal Datamem_readaddr, Datamem_writeaddr : std_logic_vector(Awidth-1 downto 0);
signal BDatamem_readaddr, BDatamem_writeaddr : std_logic_vector(Dwidth-1 downto 0);
signal Datamem_datain,Datamem_dataout : std_logic_vector(Dwidth-1 downto 0);
signal Datamem_wren : std_logic;

-- Bus --
signal BusData : std_logic_vector(Dwidth-1 downto 0);

-- Immidiate --
signal Immidiate : std_logic_vector(Dwidth-1 downto 0);

begin

----------------- Port Maps -----------------

--------- Pogram Memory Module ---------
PogramMemory_Module:	ProgMem	generic map(Dwidth,Awidth,dept)								port map(clk,TBProgmem_wren,TBProgmem_datain,TBProgmem_writeaddr,Pogram_Raddr,Pogram_DataOut);

--------- Data Memory Module ---------
DataMemory_Module:		dataMem generic map(Dwidth,Awidth,dept)								port map(clk,Datamem_wren,Datamem_datain,Datamem_writeaddr,Datamem_readaddr,Datamem_dataout);

--------- PC Module ---------
PC_Module:				PCReg	generic map(Awidth,offset_size)								port map(clk,PCin,PCsel,offset,Pogram_Raddr);

--------- IR Module ---------
IR_Module:				IR		generic map(Dwidth,Opsize,RFAwidth,ImWidth,offset_size)		port map(Pogram_DataOut,IRin,RFaddr,Opcode,WR_RegAddr,offset,IR_imm);

--------- D flip flop ---------
D_flop:					Dflop	generic map(Dwidth)											port map(clk,Mem_in,rst,BusData,BDatamem_writeaddr);

--------- ALU ---------
ALU_Module:				ALU		generic map(Dwidth)											port map(A,B,OPC,CRegin,Cflag,Zflag,Nflag);
Register_A:				Reg		generic map(Dwidth)											port map(clk,Ain,rst,BusData,A);
Register_C:				MSReg	generic map(Dwidth)											port map(clk,Cin,rst,CRegin,CRegout);

--------- Decoder ---------
Decoder_Module:			DECOD	generic map(Dwidth,Opsize)									port map(Opcode,add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done);

--------- Register File ---------
RF_Module:				RF		generic map(Dwidth,RFAwidth)								port map(clk,rst,RFin,W_RegData,WR_RegAddr,WR_RegAddr,RFData);



----------------- BiDir Bus -----------------
BusToRF_Module:			BidirPin	generic map(Dwidth)			port map(RFData,RFout,W_RegData,BusData);			
BusToALU_Module:		BidirPin	generic map(Dwidth)			port map(CRegout,Cout,B,BusData);
BusToDataMem_Module:	BidirPin	generic map(Dwidth)			port map(Datamem_dataout,Mem_out,BDatamem_readaddr,BusData);
BusToImmidiate1:		BidirPin	generic map(Dwidth)			port map(Immidiate,Imm1_in,W_RegData,BusData);
BusToImmidiate2:		BidirPin	generic map(Dwidth)			port map(Immidiate,Imm2_in,W_RegData,BusData);


----------------- Immidiate Handel -----------------
Immidiate			<=	SXT(IR_imm,Dwidth)	when	Imm1_in = '1'	else -- when IR Immidiate is the offset = 8 bits.
						SXT(('0'&IR_imm(RFAwidth-1 downto 0)),Dwidth) when Imm2_in='1' else
						unaffected;


-------------------- Mux & TB Connections --------------------
Datamem_wren		<=	TBDatamem_wren			when	TBactive = '1'	else	Mem_wr;
Datamem_datain		<=	TBDatamem_datain		when	TBactive = '1'	else	BusData;
Datamem_readaddr	<=	TBDatamem_readaddr		when	TBactive = '1'	else	BDatamem_readaddr(Awidth-1 downto 0);
Datamem_writeaddr	<=	TBDatamem_writeaddr		when	TBactive = '1'	else	BDatamem_writeaddr(Awidth-1 downto 0);

TBDatamem_dataout	<=	Datamem_dataout;

end behav;
LIBRARY ieee;
USE ieee.std_logic_1164.all;

package aux_package is
-----------------------------------------------------------------
	component PCReg is
	generic( Awidth: integer:=6;
			 offset_size: integer:=8
			);
	port(	clk,PCin: in std_logic;
			PCsel: in std_logic_vector(1 downto 0);
			IRoffset  : in std_logic_vector(7 downto 0);
			PCOut  : out std_logic_vector(Awidth-1 downto 0)
	);
		
	end component;
-----------------------------------------------------------------
	component Dflop is 
	generic( Dwidth: integer:=16);
	port(	clk,En,rst: in std_logic;	
			D  : in std_logic_vector(Dwidth-1 downto 0);
			Q  : out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component MSReg is
	generic( Dwidth: integer:=16);
	port(	clk,Enin,rst: in std_logic;	
			RegIn  : in std_logic_vector(Dwidth-1 downto 0);
			RegOut  : out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component DECOD is
	generic( Dwidth: integer:=16;
			 Opsize: integer:=4);
	port(	OpCode : in std_logic_vector(Opsize-1 downto 0);
			add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done	: out std_logic	
	);
	end component;
-----------------------------------------------------------------
	component RF is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	clk,rst,WregEn: in std_logic;	
			WregData:	in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RregData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component Reg is
	generic( Dwidth: integer:=16);
	port(	clk,Ein,rst: in std_logic;	
			Rin  : in std_logic_vector(Dwidth-1 downto 0);
			Rout  : out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component ProgMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component dataMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component BidirPinBasic is
	port(   writePin: in 	std_logic;
			readPin:  out 	std_logic;
			bidirPin: inout std_logic
	);
	end component;
-----------------------------------------------------------------
	component BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component ALU is
	generic (length : integer := 16);
	port( A, B: in std_logic_vector (length-1 downto 0);
         OPC: in std_logic_vector (3 downto 0);
         C: out std_logic_vector (length-1 downto 0);
         Cflag, Zflag, Nflag: out std_logic := '0'  --check flag reset between 
		);
	end component;
-----------------------------------------------------------------
	component FA is
	port (xi, yi, cin: in std_logic;
			  s, cout: out std_logic);
	end component;
-----------------------------------------------------------------
	component AdderSub is
	generic (n : INTEGER := 8);
	  port 
	  (  
		x,y: in STD_LOGIC_VECTOR (n-1 downto 0);
		sub_cont : in STD_LOGIC_VECTOR(2 downto 0);
		res: out STD_LOGIC_VECTOR(n-1 downto 0);
		cout: out STD_LOGIC
	  );
	end component;
-----------------------------------------------------------------
	component IR is
	generic( width: integer:=16;  --size of IR
			opCodeWidth: integer :=4; 
			rwidth: integer:= 4; --register code size
			ImWidth: integer := 8;
			offsetWidth: integer := 8
			);
	port(   command: in 	std_logic_vector(width-1 downto 0); --instruction
			IRin:	in 		std_logic;                          --enable input
			RFaddr: in std_logic_vector(1 downto 0);            --selects ra, rb, rc
			opcode: out std_logic_vector(opCodeWidth-1 downto 0);  --opcode out
			RFAddrOut:	out	 std_logic_vector(rwidth-1 downto 0); --register out
			offsetAddress: out std_logic_vector(offsetWidth-1 downto 0);
			immOut: out std_logic_vector(ImWidth-1 downto 0)
	);
	end component;
-----------------------------------------------------------------
	component Datapath is
	generic( Dwidth: 		integer:=16;
			 Awidth: 		integer:=6;
			 RFAwidth: 		integer:=4;
			 Opsize:		integer:=4;
			 m:		 		integer:=16;  -- Program Memory In Data Size
			 dept:    		integer:=64; -- Program Memory Size
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
	end component;  
--------------------------------------------------------------------
	component Control is
	generic( Dwidth: integer:=16;
			OpCodewidth: integer:=4;
			state_bits: integer:= 4   --Depends on number of states we will have
			);
	port(	clk,rst,ena: in std_logic;	
			add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done	: in std_logic;  --operations
			Nflag,Zflag, Cflag: in std_logic;                                --flags
			mem_in, mem_wr,  memOut, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in, fsmDone: out std_logic;    --enables
			RFaddr, PCsel: out std_logic_vector(1 downto 0); 
			OPC: out std_logic_vector(OpCodewidth-1 downto 0)  --ALU opcode
		
	);
	end component;
--------------------------------------------------------------------
	component top is
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
	end component;

end aux_package;


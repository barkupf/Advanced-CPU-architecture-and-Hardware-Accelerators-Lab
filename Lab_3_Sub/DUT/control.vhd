library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity Control is
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
end Control;

architecture behav of Control is
	type state is (fetch, decode, state2, state3, state4, state5, state6, reset);
	signal currState, nextState: state;  --next state?
begin
	updateState: process (clk, rst,ena)
	begin
		if (rst = '1') then 
			currState <= reset; ---------------!!!!!! RESET!!!!!
		elsif (clk'EVENT and clk = '1') then
			if (ena='1') then
				currState <= nextState;
			end if;
		end if;	
	end process;
	
	FSM: process(currState)
	begin
			case currState is
				when fetch =>
					mem_in    <= '0';
					IRin      <= '1';
					memOut    <= '0';					
					mem_wr    <= '0';
					Ain       <= '0';
					OPC       <= "1111";    
					Cout      <= '0';
					Cin       <= '0';
					RFin      <= '0';
					RFout     <= '0';
					RFaddr    <= "00";
					PCin      <= '0';
					PCsel     <= "00";  --pc=pc+1
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					nextState <= decode;	
				-------------------
			    when decode =>
				    mem_in     <= '0';
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';	
					Ain       <= '0';
					OPC       <= "1111";  --unaffected    
					Cout      <= '0';
					Cin       <= '0';
					RFin      <= '0';
					RFout     <= '0';
					RFaddr    <= "00";  --r[b] 
					PCin      <= '0';
					PCsel     <= "00";  --pc=pc+1
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					 -----R type-------------
					if (add = '1' or sub = '1' or andd = '1' or orr = '1' or xorr = '1') then				
						Ain       <= '1';  
						RFout     <= '1';
						RFaddr    <= "01";  --r[b] 
						nextState <= state2;
					------J type---------------
					elsif (jmp = '1' or jc ='1' or jnc = '1') then   
						PCin      <= '1';
						nextState <= fetch;
						if (jmp = '1' or (jc = '1' and Cflag = '1') or (jnc = '1' and Cflag = '0')) then
							PCsel     <= "01";
						else 
							PCsel     <= "00";
						end if;
					-------I type------------------
					elsif (mov = '1') then   ----move
						RFin      <= '1';
						RFaddr    <= "00";   
						PCin      <= '1';
						PCsel     <= "00"; 
						Imm1_in   <= '1';
						nextState <= fetch;
					elsif (ld = '1' or st = '1') then  ---load or store				
						Ain       <= '1';    
						Imm2_in   <= '1';
						nextState <= state4;
					elsif (done = '1') then  --done   
						PCin      <= '1';
						PCsel     <= "10"; 
						fsmDone   <= '1';
						nextState <= fetch;
					else 
						nextState <= fetch;
					end if;
					
				----------------R Type continue----------------------
				when state2 =>     --Excecution
					mem_in    <= '0';
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';					
					Ain       <= '0';    
					Cout      <= '0';
					Cin       <= '1';
					RFin      <= '0';
					RFout     <= '1';
					RFaddr    <= "10";  --r[c] 
					PCin      <= '0';
					PCsel     <= "00";  --pc=pc+1
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					if (add = '1') then
						OPC   <= "0000";  --Addition
					elsif (sub = '1') then
						OPC   <= "0001";  --subtraction
					elsif (andd	= '1') then 
						OPC   <= "0010";  --And
					elsif (orr = '1') then 
						OPC   <= "0011";  --or
					elsif (xorr = '1') then 
						OPC   <= "0100";  --xor
					else 
						OPC   <= "1111";  --unaffected
					end if;
					nextState <= state3;	
				when state3 =>     --R complete
					mem_in     <= '0';
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';					
					Ain       <= '0';    
					OPC		  <= "1111";
					Cout      <= '1';
					Cin       <= '0';
					RFin      <= '1';
					RFout     <= '0';
					RFaddr    <= "00";   
					PCin      <= '1';
					PCsel     <= "00"; 
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					nextState <= fetch;
				----------------I type continue----------------------
				when state4 =>
					mem_in    <= '0';
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';					
					Ain       <= '0';    
					OPC		  <= "0000";  --add
					Cout      <= '0';
					Cin       <= '1';
					RFin      <= '0';
					RFout     <= '1';
					RFaddr    <= "01";   --r[b]   
					PCin      <= '0';
					PCsel     <= "00"; 
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					nextState <= state5;
			    
				when state5 =>
					if (st = '1') then 
						mem_in     <= '1';  --for store
					else 
						mem_in <= '0';      -- for load and errors 
					end if;
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';					
					Ain       <= '0';    
					OPC		  <= "1111";  --unaffected
					Cout      <= '1';
					Cin       <= '0';
					RFin      <= '0';
					RFout     <= '0';
					RFaddr    <= "00";   --r[a]   
					PCin      <= '0';
					PCsel     <= "00"; 
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					nextState <= state6;
				
				when state6 =>
					mem_in    <= '0'; 
					IRin      <= '0';					
					Ain       <= '0';    
					OPC		  <= "1111";  --unaffected
					Cout      <= '0';
					Cin       <= '0';
					RFaddr    <= "00";  
					PCin      <= '1';
					PCsel     <= "00"; 
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					if (ld = '1') then
						memOut <= '1';
						RFin   <= '1';
						mem_wr    <= '0';
						RFout     <= '0';
					elsif (st = '1') then 
						memOut    <= '0';
						RFin      <= '0';
						mem_wr <= '1';
						RFout <= '1';
					end if;
					nextState <= fetch;
					
				when reset =>
					mem_in    <= '0'; 
					memOut    <= '0';
					mem_wr    <= '0';
					IRin      <= '0';					
					Ain       <= '0';    
					OPC		  <= "1111";  --unaffected
					Cout      <= '0';
					Cin       <= '0';
					RFin      <= '0';
					RFout     <= '0';
					RFaddr    <= "00";     
					PCin      <= '1';
					PCsel     <= "10"; 
					Imm1_in   <= '0';
					Imm2_in   <= '0';
					fsmDone   <= '0';
					nextState <= fetch;
				end case;
	end process;
	
end behav;

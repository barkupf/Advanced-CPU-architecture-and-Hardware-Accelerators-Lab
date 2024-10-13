library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
entity tb_control is
	
end tb_control;
architecture tb of tb_control is
	Signal rst,clk : std_logic;
	Signal add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done, Nflag,Zflag, Cflag	: std_logic;
	Signal mem_in, mem_wr,  memOut, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in, fsmDone: std_logic;
	Signal RFaddr, PCsel: std_logic_vector(1 downto 0);
	Signal OPC: std_logic_vector(3 downto 0);
	    
	
Begin	
cont: control port map (clk, rst, add,sub,andd,orr,xorr,jmp,jc,jnc,mov,ld,st,done, Nflag,Zflag, Cflag, 
						mem_in, mem_wr,  memOut, Cout, Cin, Ain, IRin, RFin, RFout, PCin, Imm1_in, Imm2_in, fsmDone,
						RFaddr, PCsel, OPC
						);
	
	
		rst_p : process
        begin
		  rst <='1', '0' after 100ns;  --for now
		  wait;
        end process; 
		
		gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		add_test: process
		begin 
			add <='0', '1' after 100ns, '0' after 500ns;
			wait;
		end process;
		
		sub_test: process
		begin 
			sub <= '0', '1' after 500ns, '0' after 900ns;
			wait;
		end process;
	
		andd_test: process
		begin 
			andd <= '0', '1' after 900ns, '0' after 1300ns;
			wait;
		end process;
	
		jmp_test: process
		begin 
			jmp <= '0', '1' after 1300ns, '0' after 1500ns;
			wait;
		end process;
	
		jc_test: process
		begin 
			jc <= '0', '1' after 1500ns, '0' after 1700ns;
			Cflag <= '1';
			wait;
		end process;
		
		mov_test: process
		begin 
			mov <= '0', '1' after 1700ns, '0' after 1900ns;
			wait;
		end process;
		
		ld_test: process
		begin 
			ld <= '0', '1' after 1900ns, '0' after 2400ns;
			wait;
		end process;
		
		st_test: process
		begin 
			st <= '0', '1' after 2400ns, '0' after 2900ns;
			wait;
		end process;
		
		done_test: process
		begin 
			done <= '0', '1' after 2900ns, '0' after 3400ns;
			wait;
		end process;
	
	
end tb;

	
	


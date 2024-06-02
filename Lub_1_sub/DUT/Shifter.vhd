LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Shifter IS
  GENERIC (	n	: INTEGER := 8;
			k	: INTEGER := 3);
  PORT ( X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		 dir	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
         cout	: OUT STD_LOGIC;
         res	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END Shifter;
-------------------------------------
ARCHITECTURE dataflow OF Shifter IS
	SUBTYPE vector IS STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	TYPE matrix IS ARRAY (k DOWNTO 0) OF vector;
	SIGNAL matx : matrix;
	SIGNAL cout_vec : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
	SIGNAL Y_temp, Out_temp	:	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	
BEGIN
	--- setting the shifter by dir - if shifting right replace the order of Y, if dir is undefine enter zero vector, setting the first carry to be '0'
	first :	FOR i in n-1 DOWNTO 0 GENERATE
				Y_temp(n-1-i) <= Y(i);
			END GENERATE first;
			
			matx(0)(n-1 DOWNTO 0) <= Y(n-1 DOWNTO 0) WHEN dir = "000" ELSE 
									 Y_temp(n-1 DOWNTO 0) WHEN dir = "001" ELSE
									 (OTHERS=>'0');
			
			cout_vec(0) <= '0';
	
	--- shifting left if in X there is '1'
	shift :	FOR row in 1 to k GENERATE
				matx(row)(2**(row-1)-1 DOWNTO 0) <= (OTHERS=>'0') WHEN X(row-1) = '1' ELSE
													matx(row-1)(2**(row-1)-1 DOWNTO 0) WHEN X(row-1)='0';
				matx(row)(n-1 DOWNTO 2**(row-1)) <= matx(row-1)(n-1-2**(row-1) DOWNTO 0) WHEN X(row-1) = '1' ELSE
													matx(row-1)(n-1 DOWNTO 2**(row-1));
			END GENERATE shift;
	--- geting the results, if shifting right we need to replace the order again
	If_shl:	FOR i in n-1 DOWNTO 0 GENERATE
					Out_temp(n-1-i) <= matx(k)(i);
			END GENERATE If_shl;
	
	result: res(n-1 DOWNTO 0)  <=	matx(k)(n-1 DOWNTO 0) WHEN dir = "000" ELSE
									Out_temp(n-1 DOWNTO 0) WHEN dir = "001" ELSE
									(OTHERS=>'0');
	--- getting the carry
	carry :	FOR car in 1 to k-1 GENERATE
				cout_vec(car) <= matx(car-1)(n-2**(car-1)) WHEN X(car-1) = '1' ELSE
								 cout_vec(car-1);
			END GENERATE carry;
			
			cout <= cout_vec(k-1);
END dataflow;
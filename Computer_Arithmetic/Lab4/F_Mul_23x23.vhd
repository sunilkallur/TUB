----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:19:06 01/22/2014 
-- Design Name: 
-- Module Name:    F_Mul_23x23 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity F_Mul_23x23 is
    Port ( a : in  STD_LOGIC_VECTOR (22 downto 0);
           b : in  STD_LOGIC_VECTOR (22 downto 0);
			  clk: in STD_LOGIC;
           rst: in STD_LOGIC;
			  P : out  STD_LOGIC_VECTOR (22 downto 0);
			  zero: out STD_LOGIC:='0';
			  sign: out STD_LOGIC:='0';
			  overflow: out STD_LOGIC:='0');
end F_Mul_23x23;

architecture Behavioral of F_Mul_23x23 is

Component CL_Adder is
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           y : in  STD_LOGIC_VECTOR (7 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (7 downto 0);
           cout : out  STD_LOGIC);
end Component;


Component Mul_16x16 is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           P : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Regstr is
	port ( a : in STD_LOGIC_VECTOR (22 downto 0);
	b : in STD_LOGIC_VECTOR (22 downto 0);
	clk : in STD_LOGIC;
	rst : in STD_LOGIC;
	a_reg : out STD_LOGIC_VECTOR (22 downto 0);
	b_reg : out STD_LOGIC_VECTOR (22 downto 0));
end Component;

Component Reg_product is
    Port ( a : in  STD_LOGIC_VECTOR (22 downto 0);
			  P_P: in STD_LOGIC_VECTOR (31 downto 0);	
			  clk : in STD_LOGIC;
	        rst : in STD_LOGIC;
           b : out  STD_LOGIC_VECTOR (22 downto 0));
end Component;

signal P_I : std_logic_vector(7 downto 0);
signal P_P : std_logic_vector(31 downto 0);
signal cout,cout1 : std_logic;
signal a_I,b_I : std_logic_vector(15 downto 0);
signal p_final : std_logic_vector(7 downto 0);
signal a_reg :  STD_LOGIC_VECTOR (22 downto 0);
signal b_reg :  STD_LOGIC_VECTOR (22 downto 0);
signal clkby2: std_logic := '0';
signal k:std_logic_vector(1 downto 0):="00";
signal m: std_logic;
signal product : std_logic_vector(22 downto 0);


begin

	
process(clk)
begin
	if clk'event and clk='1' then
		if((a_reg = "00000000000000000000000") or (b_reg = "00000000000000000000000")) then
			P <= "00000000000000000000000";
			sign <= '0';
			overflow <= '0';
			zero <= '1';
			
		else
				
				overflow <= m;
				if (m ='1') then 
						
							if (product(21)='0') then -- overflow
								P(21 downto 14) <= "11111111";
								P(13 downto 0) <= (others => '0');
								P(22) <= '0';
							else 									-- underflow
								P(21 downto 14) <=(others => '0');
								P(13 downto 0) <= (others => '0');
								P(22) <= '0';
							end if;
				else		
				P <= product;
				sign <=product(22);
				zero <= '0';
				end if;
			
		end if;
	end if;
end process;

vreg : process (P_final,P_P)
				begin

							
							k <= (P_P(29) & P_P(28));
							product(21 downto 14) <= P_final;
							product(22) <= a_reg(22) xor b_reg(22);
							if (k="01") then
								product(13 downto 0) <= P_P(27 downto 14);
							else
								product(13 downto 0) <= P_P(28 downto 15);
							end if;

						
end process;

								
R0: Regstr port map(a(22 downto 0),b(22 downto 0),clk,rst,a_reg,b_reg);


--Extracting and Adding Exponent parts
A0: CL_Adder port map(a_reg(21 downto 14),b_reg(21 downto 14),'0',P_I(7 downto 0),cout);


--Multiplying Significand parts
a_I <= '0' & '1' & a_reg(13 downto 0);
b_I <= '0' & '1' & b_reg(13 downto 0);

M1:Mul_16x16 port map(a_I,b_I,P_P(31 downto 0));


--Adding the biase and the multiplication shift deciding bit

A1:CL_Adder port map(P_I(7 downto 0),"10000001",P_P(29),P_final,cout1);

m <= cout xor cout1 xor '1'; 

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:52:31 11/13/2013 
-- Design Name: 
-- Module Name:    CSA - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CSA is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           s : out  STD_LOGIC_VECTOR (7 downto 0);
           c : out  STD_LOGIC);
end CSA;

architecture Structural of CSA is

component RG is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (1 downto 0);
           c : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component selector is
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           s_in : in  STD_LOGIC_VECTOR (1 downto 0);
           c_in : in  STD_LOGIC_VECTOR (1 downto 0);
           s : out  STD_LOGIC_VECTOR (1 downto 0);
           c : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component Sel6in is
    Port ( sel_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
	        s_stg1 : in  STD_LOGIC_VECTOR (1 downto 0);
	        s_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
			  c_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
           s14_stg3 : out STD_LOGIC_VECTOR (1 downto 0);
			  s24_stg3 : out STD_LOGIC_VECTOR (1 downto 0);
			  c24_stg3 : out  STD_LOGIC_VECTOR (1 downto 0));
			  
end component;

component Sel10in is
    Port ( sel : in  STD_LOGIC;
           s14 : in  STD_LOGIC_VECTOR (1 downto 0);
           s24 : in  STD_LOGIC_VECTOR (1 downto 0);
           s34 : in  STD_LOGIC_VECTOR (3 downto 0);
           c34 : in  STD_LOGIC_VECTOR (1 downto 0);
           s : out  STD_LOGIC_VECTOR (3 downto 0);
           c : out  STD_LOGIC);
end component;

component HA is
port(
a : in STD_LOGIC;
b : in STD_LOGIC;
s : out STD_LOGIC;
co : out STD_LOGIC);

end component;

signal c10, c11 : std_logic;
signal n11,n12,n13,n14,n15,n16 : std_logic_vector(1 downto 0);
signal n17 : std_logic_vector(3 downto 0);
type stg_1 is array (1 to 7)of std_logic_vector(1 downto 0);
signal s1,c1 : stg_1;
type stg_2 is array (1 to 3)of std_logic_vector(1 downto 0);
signal s2,c2 : stg_2;
signal dummy : std_logic;
signal s13,s34,c34 : std_logic_vector(1 downto 0);

begin

u1 : HA port map (a(0),b(0),s(0),c10);

u2 : for i in 1 to 7 generate
     u3 : RG port map (a(i),b(i),s1(i),c1(i));
	  end generate u2;

n11 <= c10 & c10 ;
s1_1: selector port map (n11,s1(1),c1(1),n12,n13);
s(1) <= n12(0);
 --c10 <= n13(1);
s1_2: selector port map (c1(2),s1(3),c1(3),s2(1),c2(1));
s1_3: selector port map (c1(4),s1(5),c1(5),s2(2),c2(2));
s1_4: selector port map (c1(6),s1(7),c1(7),s2(3),c2(3));

-- stage 2 of selector


--n11 <= n13;

s2_1: sel6in port map (n13, s1(2),s2(1),c2(1),n14, n15, n16) ;

s(2)<= n14(0); 
s(3)<= n15(0);
c11 <= n16(0);

s2_2: sel6in port map (c2(2), s1(6),s2(3),c2(3),s13,s34,c34);

-- stage 3 of selector
n17 <= s34 & s13;
s3_1: sel10in port map (c11,s1(4),s2(2),n17,c34,s(7 downto 4),c);

end Structural;


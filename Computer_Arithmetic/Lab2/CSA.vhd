----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:42 12/11/2013 
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
use work.CS_Adder_Package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CSA is
    Port ( a : in  STD_LOGIC_VECTOR (14 downto 0);
           b : in  STD_LOGIC_VECTOR (14 downto 0);
           c : in  STD_LOGIC_VECTOR (14 downto 0);
           d : in  STD_LOGIC_VECTOR (14 downto 0);
           S : out  STD_LOGIC_VECTOR (14 downto 0);
           Cry : out  STD_LOGIC_VECTOR (14 downto 0));
end CSA;

architecture Behavioral of CSA is

component Counter4to2 is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           d : in  STD_LOGIC;
			  ti : in STD_LOGIC;
           S : out  STD_LOGIC;
           Cry : out  STD_LOGIC;
			  t0: out STD_LOGIC);
end component;

--signal m : SE_CSA_Array ;
signal ti : std_logic_vector(15 downto 0);

begin

ti(0)<= '0' ; 

u0: for i in 0 to 14 generate
		u1:Counter4to2 port map(a(i),b(i),c(i),d(i),ti(i),S(i),Cry(i),ti(i+1));
	end generate u0;
	

end Behavioral;


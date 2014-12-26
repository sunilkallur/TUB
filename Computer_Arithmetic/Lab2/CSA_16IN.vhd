----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:53:57 12/14/2013 
-- Design Name: 
-- Module Name:    CSA_16IN - Behavioral 
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
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CSA_16IN is
    Port ( a : in  input_array;
			  S : out std_logic_vector(14 downto 0));
end CSA_16IN;

architecture Behavioral of CSA_16IN is



component CSA is
    Port ( a : in  STD_LOGIC_VECTOR (14 downto 0);
           b : in  STD_LOGIC_VECTOR (14 downto 0);
           c : in  STD_LOGIC_VECTOR (14 downto 0);
           d : in  STD_LOGIC_VECTOR (14 downto 0);
           S : out  STD_LOGIC_VECTOR (14 downto 0);
           Cry : out  STD_LOGIC_VECTOR (14 downto 0));
end component;


component CL_Adder is
    Port ( x : in  STD_LOGIC_VECTOR (14 downto 0);
           y : in  STD_LOGIC_VECTOR (14 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (14 downto 0);
           cout : out  STD_LOGIC);
end component;


signal S1,C : SE_CSA_Array;
signal b: se_array;
signal S_20,C_20,S_21,C_21,CC : std_logic_vector(14 downto 0); 
signal FSum,FC : std_logic_vector (14 downto 0);
signal cout : std_logic;
begin

--stg1 



k0: for i in 0 to 15 generate
	b(i)(14 downto 0) <= a(i)(10) & a(i)(10) & a(i)(10) & a(i)(10) & a(i)(10 downto 0);
	end generate k0;

		
u0: CSA port map(b(0),b(1),b(2),b(3),S1(0),C(0));
u1: CSA port map(b(4),b(5),b(6),b(7),S1(1),C(1));
u2: CSA port map(b(8),b(9),b(10),b(11),S1(2),C(2));
u3: CSA port map(b(12),b(13),b(14),b(15),S1(3),C(3));

--stg2

u4: CSA port map(S1(0),S1(1),S1(2),S1(3),S_20,C_20);
u5: CSA port map(C(0),C(1),C(2),C(3),S_21,C_21);

--stg3

CC<= sl(C_21);

u6: CSA port map(S_20,sl(C_20),sl(S_21),sl(CC),FSum,FC);

-- Fast adder 

u7 : CL_Adder port map(FSum,sl(FC),'0',S,cout);

end Behavioral;


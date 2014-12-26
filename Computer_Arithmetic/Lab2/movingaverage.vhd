----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:25 12/14/2013 
-- Design Name: 
-- Module Name:    movingaverage - Structural 
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

entity movingaverage is
    Port ( sin : in  STD_LOGIC_VECTOR (10 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sout : out  STD_LOGIC_VECTOR (10 downto 0));
end movingaverage;

architecture Structural of movingaverage is

component Regstr is
	port ( d : in STD_LOGIC_VECTOR (10 downto 0);
	clk : in STD_LOGIC;
	rst : in STD_LOGIC;
	q : out STD_LOGIC_VECTOR (10 downto 0));
end component;

component CSA_16IN is
    Port ( a : in  input_array;
			  S : out std_logic_vector(14 downto 0));
end component;

signal s: input_array;
signal sum_out,sum_div : std_logic_vector(14 downto 0);

begin

--wait for first 15 samples shift



u0: for i in 15 downto 1 generate
		u1:regstr port map(s(i-1)(10 downto 0),clk,rst,s(i)(10 downto 0));
end generate u0;

u7:regstr port map(sin,clk,rst,s(0)(10 downto 0));

--calculate the sum 

u2: CSA_16IN port map (S,Sum_out);


--Sum_div <= Sum_out srl 4 ; --divide by 16

--sl(sum_out);

Sout <= sum_out(14 downto 4); --divide by 16

end Structural;


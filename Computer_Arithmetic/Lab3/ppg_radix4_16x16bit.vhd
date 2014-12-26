----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:35:10 01/11/2014 
-- Design Name: 
-- Module Name:    ppg_radix4_16x16bit - Behavioral 
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

entity ppg_radix4_16x16bit is
    Port ( a_i_minus_1 : in  STD_LOGIC;
           a_i : in  STD_LOGIC;
           a_i_plus_1 : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           P_i : out  STD_LOGIC_VECTOR (16 downto 0);
			  T   : out std_logic);
end ppg_radix4_16x16bit;

architecture Structural of ppg_radix4_16x16bit is

signal sel1,sel2 : std_logic;

begin

-- Encoder Design
sel1 <= a_i_minus_1 xor a_i ;

sel2 <= (a_i_minus_1 and a_i and (not a_i_plus_1)) or ((not a_i_minus_1) and (not a_i) and (a_i_plus_1));

-- partial product Selector 

p_i(0) <= a_i_plus_1 xor (b(0) and sel1);

U0: for i in 1 to 15 generate
		p_i(i) <= a_i_plus_1 xor ((b(i) and sel1) or (b(i-1) and sel2)); 
	 end generate U0;	
	 
p_i(16) <= a_i_plus_1 xor ((b(15) and sel1) or (b(15) and sel2));

T <= a_i_plus_1 ;
	 
end Structural;


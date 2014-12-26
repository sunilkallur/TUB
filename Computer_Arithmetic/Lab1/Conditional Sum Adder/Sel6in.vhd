----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:27 11/13/2013 
-- Design Name: 
-- Module Name:    Sel6in - Behavioral 
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

entity Sel6in is
    Port ( sel_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
	        s_stg1 : in  STD_LOGIC_VECTOR (1 downto 0);
	        s_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
			  c_stg2 : in  STD_LOGIC_VECTOR (1 downto 0);
           s14_stg3 : out STD_LOGIC_VECTOR (1 downto 0);
			  s24_stg3 : out STD_LOGIC_VECTOR (1 downto 0);
			  c24_stg3 : out  STD_LOGIC_VECTOR (1 downto 0));
			  
end Sel6in;

architecture Behavioral of Sel6in is

begin

s14_stg3 <= s_stg1(0) & s_stg1(0) WHEN sel_stg2 = "00" ELSE
            s_stg1(1) & s_stg1(1) WHEN sel_stg2 = "11" ELSE
				s_stg1;
				
s24_stg3 <= s_stg2(0) & s_stg2(0) WHEN sel_stg2 = "00" ELSE
            s_stg2(1) & s_stg2(1) WHEN sel_stg2 = "11" ELSE
				s_stg2;
				
c24_stg3 <= c_stg2(0) & c_stg2(0) WHEN sel_stg2 = "00" ELSE
            c_stg2(1) & c_stg2(1) WHEN sel_stg2 = "11" ELSE
				c_stg2;
				
end Behavioral;


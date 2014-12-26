----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:23 11/13/2013 
-- Design Name: 
-- Module Name:    selector - Behavioral 
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

entity selector is
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           s_in : in  STD_LOGIC_VECTOR (1 downto 0);
           c_in : in  STD_LOGIC_VECTOR (1 downto 0);
           s : out  STD_LOGIC_VECTOR (1 downto 0);
           c : out  STD_LOGIC_VECTOR (1 downto 0));
end selector;

architecture Behavioural of selector is

begin
   
s<= s_in(0) & s_in(0) WHEN sel = "00" ELSE
    s_in(1) & s_in(1)WHEN sel = "11" ELSE
	 s_in;
	 
c<= c_in(0) & c_in(1) WHEN sel = "00" ELSE
    c_in(1) & c_in(1) WHEN sel = "11" ELSE
    c_in;
	  
end Behavioural;


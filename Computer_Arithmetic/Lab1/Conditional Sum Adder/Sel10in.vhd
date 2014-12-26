----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:46:47 11/13/2013 
-- Design Name: 
-- Module Name:    Sel10in - Behavioral 
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

entity Sel10in is
    Port ( sel : in  STD_LOGIC;
           s14 : in  STD_LOGIC_VECTOR (1 downto 0);
           s24 : in  STD_LOGIC_VECTOR (1 downto 0);
           s34 : in  STD_LOGIC_VECTOR (3 downto 0);
           c34 : in  STD_LOGIC_VECTOR (1 downto 0);
           s : out  STD_LOGIC_VECTOR (3 downto 0);
           c : out  STD_LOGIC);
end Sel10in;

architecture Behavioral of Sel10in is

begin

s <= s34(0) & s34(2) & s24(0) & s14(0) WHEN sel = '0' ELSE
     s34(1) & s34(3) & s24(1) & s14(1); 
	  
c <= c34(0) WHEN sel = '0' ELSE
     c34(1);
	  
end Behavioral;


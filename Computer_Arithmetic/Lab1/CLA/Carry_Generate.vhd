----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:55:06 11/20/2013 
-- Design Name: 
-- Module Name:    Carry_Generate - Structural 
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

entity Carry_Generate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           g : out  STD_LOGIC;
           p : out  STD_LOGIC);
end Carry_Generate;

architecture Structural of Carry_Generate is

begin

g<= a and b;
p<= a xor b;

end Structural;


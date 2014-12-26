----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:38 11/20/2013 
-- Design Name: 
-- Module Name:    Summation - Structural 
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

entity Summation is
    Port ( --g : in  STD_LOGIC;
           p : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC
           --c : out  STD_LOGIC
			  );
end Summation;

architecture Structural of Summation is

begin

s<= p xor cin ;
--c<= g or (p and cin);

end Structural;


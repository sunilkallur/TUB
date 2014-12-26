----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:22:26 05/24/2013 
-- Design Name: 
-- Module Name:    Reg11bits - Behavioral 
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

entity Reg11bits is
	 generic (n : integer := 8; edge : std_logic := '1');
    Port ( d : in  STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(n-1 downto 0));
end Reg11bits;

architecture Behavioral of Reg11bits is

begin
	ureg : process (rst, clk)
	begin
		if rst = '1' then
			q <= (others=>'0'); 
      else
			if clk'event and  clk=edge then
				q <= d; 
         end if;
      end if;
   end process;
end Behavioral;


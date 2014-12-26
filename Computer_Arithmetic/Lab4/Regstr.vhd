----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:33 12/14/2013 
-- Design Name: 
-- Module Name:    Regstr - Behavioral 
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

entity Regstr is
	port ( a : in STD_LOGIC_VECTOR (22 downto 0);
	b : in STD_LOGIC_VECTOR (22 downto 0);
	clk : in STD_LOGIC;
	rst : in STD_LOGIC;
	a_reg : out STD_LOGIC_VECTOR (22 downto 0);
	b_reg : out STD_LOGIC_VECTOR (22 downto 0));
end Regstr;


architecture Behavioral of Regstr is
	begin
			ureg : process (rst, clk)
				begin
					if rst = '1' then
					a_reg <= (others=>'0');
					b_reg <= (others=>'0');
					else
						if clk'event and clk='1' then
							if((a /= "0000000000000000000000") and (b /= "0000000000000000000000")) then
								a_reg <= a;
								b_reg <= b;
							end if;
						end if;
					end if;
				end process;
end Behavioral;


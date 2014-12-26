----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:51:18 09/13/2013 
-- Design Name: 
-- Module Name:    normal_multiplier - Behavioral 
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
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity normal_multiplier is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           p : out  STD_LOGIC_VECTOR (15 downto 0));
end normal_multiplier;

architecture Behavioral of normal_multiplier is

	signal a_i, b_i : std_logic_vector(7 downto 0);
	
	component Reg11bits is
	 generic (n : integer := 8);
    Port ( d : in  STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
begin

	u_reg_a : reg11bits generic map (n=>8) port map (clk=>clk,rst=>rst, d=>a, q=>a_i);
	u_reg_b : reg11bits generic map (n=>8) port map (clk=>clk,rst=>rst, d=>b, q=>b_i);
	
	p_mul: process (clk, rst)
	begin
		if rst = '1' then
			p <= (others=>'0');
		else
			if clk'event and clk = '1' then
				p <= a_i * b_i;
			end if;
		end if;
	
	end process;

end Behavioral;


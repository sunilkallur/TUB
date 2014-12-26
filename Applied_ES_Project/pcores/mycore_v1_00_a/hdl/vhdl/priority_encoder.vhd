----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:04 09/12/2013 
-- Design Name: 
-- Module Name:    priority_encoder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.approximate_multiplier_pkg.all;

entity priority_encoder is
	generic (size: integer := 8);
	Port ( a : in  STD_LOGIC_VECTOR (size-1 downto 0);
		  kv: out std_logic;
		  k : out STD_LOGIC_VECTOR (log2(size)-1 downto 0);
		  a_o : out  STD_LOGIC_VECTOR (size-1 downto 0);
		  clk , rst: in  STD_LOGIC);	
end priority_encoder;

architecture Behavioral of priority_encoder is
 signal k_i : std_logic_vector(log2(size)-1 downto 0);
 signal kv_i: std_logic;
 
 constant zeros : std_logic_vector(size-1 downto 0) := (others=>'0');
begin

--		 k_i <= "111" when a(7)='1' else
--				  "110" when a(6)='1' else
--				  "101" when a(5)='1' else
--				  "100" when a(4)='1' else
--				  "011" when a(3)='1' else
--				  "010" when a(2)='1' else
--				  "001" when a(1)='1' else
--				  "000";
--				  
--		 kv_i <= '1' when a = "00000000" else '0';

enc_led_zeros: process (a)
begin
	for i in size-1 downto 1 loop
		if a(i) = '1' then
			k_i<= std_logic_vector(to_unsigned(i,log2(size)));
			exit;
		end if;
	end loop;
end process;

kv_i <= '1' when a = zeros else '0';


enc_proc : process (clk, rst)
begin
	if rst = '1' then
		k <= (others=>'0');
		a_o <= (others=>'0');
		kv<= '0';
	else
		if clk'event and clk = '0' then
				k <= k_i;
				kv<= kv_i;
				a_o <= a;
		end if;
	end if;

end process;


end Behavioral;



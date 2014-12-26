----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:19 09/16/2013 
-- Design Name: 
-- Module Name:    anti_log - Behavioral 
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

use work.approximate_multiplier_pkg.all;

entity anti_log is
	 generic (size : integer := 8);
    Port ( p_log : in  STD_LOGIC_VECTOR ((log2(size)+size-1) downto 0);
           p : out  STD_LOGIC_VECTOR ((size*2)-1 downto 0));
end anti_log;

architecture Behavioral of anti_log is

	component barrel_shifting is
	 generic ( bi : integer := 8; bo  : integer := 16; layers: integer := 4);
    Port ( x_p : in  STD_LOGIC_VECTOR (bi-1 downto 0);
		 s_l : in std_logic_vector(layers-1 downto 0);
           p : out  STD_LOGIC_VECTOR (bo-1 downto 0));
	end component;

	signal k_p : std_logic_vector (log2(size) downto 0);
	
	signal x_p : std_logic_vector (size-2 downto 0);
	
	signal x_p_i : std_logic_vector (size-1 downto 0);
	
	signal log_index : integer range 0 to (2*size)-1;
begin
	
	k_p  <= p_log((log2(size)+size-1) downto size-1);
	
	x_p  <= p_log(size-2  downto 0);
	
	x_p_i<= '1'&x_p;
		
	u_barrel : barrel_shifting generic map (bi=>size, bo=>2*size,layers=>log2(size)+1) port map (x_p=>x_p_i,s_l=>k_p,p=>p);

end Behavioral;


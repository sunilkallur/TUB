----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:15:00 09/12/2013 
-- Design Name: 
-- Module Name:    approximate_multiplier - Behavioral 
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
--use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.approximate_multiplier_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity approximate_multiplier is
	 generic (size : integer := 16);
    Port ( a : in  STD_LOGIC_VECTOR (size-1 downto 0);
           b : in  STD_LOGIC_VECTOR (size-1 downto 0);
           clk : in  STD_LOGIC;
           p : out  STD_LOGIC_VECTOR ((size*2)-1 downto 0);
			  c : out std_logic_vector(3 downto 0);
			  a_o : out  STD_LOGIC_VECTOR (size-1 downto 0);
           b_o : out  STD_LOGIC_VECTOR (size-1 downto 0);
           rst : in  STD_LOGIC);
end approximate_multiplier;

architecture Behavioral of approximate_multiplier is
	component decompisition is
		 generic (size : integer := 8);
		 Port ( a 	 : in  STD_LOGIC_VECTOR (size-1 downto 0);
				  comp : out  STD_LOGIC_VECTOR ((log2(size)+size-2) downto 0);
				  --k	 : out  std_logic_vector ( 2 downto 0);
				  --x	 : out  std_logic_vector ( 6 downto 0);
				  a_o  : out std_logic_vector (size-1 downto 0);
				  z , o   : out std_logic;
				  clk  : in  STD_LOGIC;
				  rst  : in  STD_LOGIC);
	end component;
	
	component anti_log is
	 generic (size : integer := 8);
    Port ( p_log : in  STD_LOGIC_VECTOR ((log2(size)+size-1) downto 0);
           p : out  STD_LOGIC_VECTOR ((size*2)-1 downto 0));
	end component;
	
	component Reg11bits is
	 generic (n : integer := 8; edge : std_logic := '1');
    Port ( d : in  STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
	
	signal comp_a, comp_b : std_logic_vector ((log2(size)+size-2) downto 0);
	--signal k_a , k_b : std_logic_vector (2 downto 0);
	--signal x_a , x_b : std_logic_vector (6 downto 0);
	
	signal z_a , z_b : std_logic;
	signal o_a , o_b : std_logic;
	
	signal p_log : std_logic_vector ((log2(size)+size-1) downto 0);
	
	signal p_log_i : std_logic_vector ((log2(size)+size-1) downto 0);
	
	signal p_i : std_logic_vector ((size*2)-1 downto 0);
	
	signal p_I_r : std_logic_vector ((size*2)-1 downto 0);
	
	signal c_i : std_logic_vector (3 downto 0);
	
	signal a_i1, a_i2, a_i3 : std_logic_vector(size-1 downto 0);
	signal b_i1, b_i2, b_i3 : std_logic_vector(size-1 downto 0);
	
begin
	--k=> k_a, x=>x_a,
	--k=> k_b, x=>x_b,
	u_decomp_a : decompisition generic map (size=>size) port map (a=>a, comp=>comp_a,  z=>z_a, o=>o_a, clk=>clk, rst=> rst, a_o=>a_i1);
	u_decomp_b : decompisition generic map (size=>size) port map (a=>b, comp=>comp_b,  z=>z_b, o=>o_b, clk=>clk, rst=> rst, a_o=>b_i1);
	
	p_log_i <= std_logic_vector(('0'&unsigned(comp_a))+('0'&unsigned(comp_b)));
	
	u_p_log_reg : Reg11bits generic map (n=>log2(size)+size, edge =>'0') port map (d=>p_log_i,clk=>clk,rst=>rst,q=>p_log);
	
	u_debug_a : Reg11bits generic map (n=>size, edge =>'0') port map (d=>a_i1,clk=>clk,rst=>rst,q=>a_i2);
	u_debug_b : Reg11bits generic map (n=>size, edge =>'0') port map (d=>b_i1,clk=>clk,rst=>rst,q=>b_i2);
	
	u_antilog : anti_log generic map (size=>size) port map (p_log=>p_log, p=>p_i);
	
	p_i_r <= p_i;
	--u_p_ulog_reg : Reg11bits generic map (n=>16, edge =>'1') port map (d=>p_i,clk=>clk,rst=>rst,q=>p_i_r);
	c <= c_i;
	
	anti_log_p : process (clk, rst)
	begin
		if rst = '1' then
			p <= (others=>'0');
			c_i <= (others=>'0');
			a_o <= (others=>'0');
			b_o <= (others=>'0');
		else
			if clk'event and clk = '1' then
				p <= (others=>'0');
				a_o <= a_i2;
				b_o <= b_i2;
				c_i <= std_logic_vector(unsigned (c_i) + 1);
				if z_a = '1' or z_b = '1' or o_a = '1' or o_b = '1' then
					
					if z_a = '1' or z_b = '1' then
						p <= (others=>'0');
					end if;
					
					if o_a = '1' then
						p(size-1 downto 0) <= b;
						--p(15 downto 8) <= (others=>'0');
					end if;
					
					if o_b = '1' then
						p(size-1 downto 0) <= a;
						--p(15 downto 8) <= (others=>'0');
					end if;
				else
					p<= p_i_r;
				end if;
			end if;		
		end if;	
	end process;
	

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:52:28 09/12/2013 
-- Design Name: 
-- Module Name:    decompisition - Behavioral 
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

entity decompisition is
	 generic (size : integer := 8);
		 Port ( a 	 : in  STD_LOGIC_VECTOR (size-1 downto 0);
				  comp : out  STD_LOGIC_VECTOR ((log2(size)+size-2) downto 0);
				  --k	 : out  std_logic_vector ( 2 downto 0);
				  --x	 : out  std_logic_vector ( 6 downto 0);
				  a_o  : out std_logic_vector (size-1 downto 0);
				  z , o   : out std_logic;
				  clk  : in  STD_LOGIC;
				  rst  : in  STD_LOGIC);
end decompisition;

architecture Behavioral of decompisition is
	component priority_encoder is
	 generic (size: integer := 8);
    Port ( a : in  STD_LOGIC_VECTOR (size-1 downto 0);
			  kv: out std_logic;
           k : out STD_LOGIC_VECTOR (log2(size)-1 downto 0);
			  a_o : out  STD_LOGIC_VECTOR (size-1 downto 0);
           clk , rst: in  STD_LOGIC);
	end component;
	
	component Reg11bits is
	 generic (n : integer := 8; edge : std_logic:='1');
    Port ( d : in  STD_LOGIC_VECTOR(n-1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
	
--	component barrel_shifting is
--	 generic ( bi : integer := 8; bo  : integer := 16);
--    Port ( x_p : in  STD_LOGIC_VECTOR (bi-1 downto 0);
--			  s_l : in std_logic_vector(3 downto 0);
--           p : out  STD_LOGIC_VECTOR (bo-1 downto 0));
--	end component;
--	
--	component barrel_shifting_left is
--	 generic ( bi : integer := 8; bo  : integer := 16);
--    Port ( x_p : in  STD_LOGIC_VECTOR (bi-1 downto 0);
--			  s_l : in std_logic_vector(3 downto 0);
--           p : out  STD_LOGIC_VECTOR (bo-1 downto 0));
--	end component;
	
	signal k_i : std_logic_vector (log2(size)-1 downto 0);
	
	
	signal k_c: integer range 0 to size-1;
	
	signal k_v: std_logic;
	
	signal k_v_r: std_logic;
	
	signal a_i: std_logic_vector (size-1 downto 0);
	
	signal a_i1: std_logic_vector (size-1 downto 0);
	
	--signal x_i_t : std_logic_vector (6 downto 0);
	signal k_i_r : std_logic_vector (log2(size)-1 downto 0);
	
begin
	
	in_reg : reg11bits generic map (n=>size, edge=>'1') port map (clk=>clk, rst=>rst, d=>a, q=>a_i);
	
	k_c <= to_integer (unsigned(k_i));	
	
	u_p_enc : priority_encoder generic map (size=>size) port map (a=>a_i,kv=>k_v,k=>k_i,clk=>clk,rst=>rst,a_o=>a_i1);
	
	--u_reg : reg11bits generic map (n=>7) port map (clk=>clk,rst=>rst, d=>a(6 downto 0), q=>a_i);
	
	--u_reg_k_i : reg11bits generic map (n=>3) port map (clk=>clk,rst=>rst, d=>k_i, q=>k_i_r);
	
	--u_reg_k_v : reg11bits generic map (n=>1) port map (clk=>clk,rst=>rst, d(0)=>k_v, q(0)=>k_v_r);
	
	--u_barrel  : barrel_shifting_left generic map (bi=>7, bo=>7) port map (x_p=>a_i, s_l=>('1'&k_i), p=>x_i_t);
	
	
	dec_proc: process (clk, rst)
		variable logfrac_i : integer;
		variable x_i : std_logic_vector (size-2 downto 0);
	begin
		if rst = '1' then
			comp <= (others=>'0');
			z <= '0';
			o <= '0';
			logfrac_i := 0;
			x_i := (others=>'0');
			a_o <= (others=>'0');
		else		
			if clk'event and clk = '1' then
				a_o <= a_i1;
				if k_v = '1' or k_c = 0 then
					comp <= (others=>'0');
					
					if k_v = '1' then
						z <= '1';
						o <= '0';
					else
						z <= '0';
						o <= '1';
					end if;
				else
					
					logfrac_i := k_c -1;
					
					x_i(size-2 downto size-k_c-1) := a_i(logfrac_i downto 0);
					
					if k_c < size-1 then
						x_i (size-k_c-2 downto 0) := (others=>'0');
					end if;

					--x_i := x_i_t;
					
					comp <= k_i & x_i;
					
					z <= '0';
					o <= '0';
				end if;
			end if;
		end if;	
	end process;
end Behavioral;


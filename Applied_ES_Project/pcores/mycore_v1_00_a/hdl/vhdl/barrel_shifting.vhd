----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:57:31 09/13/2013 
-- Design Name: 
-- Module Name:    barrel_shifting - Behavioral 
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

entity barrel_shifting is
	generic ( bi : integer := 32; bo  : integer := 64;layers: integer := 5);
	
    Port ( x_p : in  STD_LOGIC_VECTOR (bi-1 downto 0);
			  s_l : in std_logic_vector(layers-1 downto 0);
           p : out  STD_LOGIC_VECTOR (bo-1 downto 0));
end barrel_shifting;

architecture Behavioral of barrel_shifting is
		
	component mux_2_1 is
	 generic (n : in integer:= 8);
    Port ( a : in  STD_LOGIC_VECTOR (n-1 downto 0);
           b : in  STD_LOGIC_VECTOR (n-1 downto 0);
           s : in  STD_LOGIC;
           f : out  STD_LOGIC_VECTOR (n-1 downto 0));
	end component;
	
	signal x_p_i : std_logic_vector (bo downto 0);
	
	signal x_p_i_1_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_1: std_logic_vector (bo+1 downto 0);
	
	signal x_p_i_2_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_2: std_logic_vector (bo+3 downto 0);
	
	signal x_p_i_3_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_3: std_logic_vector (bo+7 downto 0);
	
	signal x_p_i_4_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_4: std_logic_vector (bo+15 downto 0);
	
	signal x_p_i_5_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_5: std_logic_vector (bo+31 downto 0);
	
	signal x_p_i_6_s: std_logic_vector (bo-1 downto 0);
	signal x_p_i_6: std_logic_vector (bo+63 downto 0);
	
begin
	
	gen_bo_bi : if bo=bi generate
		x_p_i <= '0' & x_p;
	end generate;
	
	gen_bo_g_bi : if bo>bi generate
		x_p_i <= '0' & x_p & (bo-bi-1 downto 0=>'0');
	end generate;
	
	-------- Layer 1 ---------
	gen_layer_1: if layers>0 generate
		u_m_1 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i(bo downto 1), b=>x_p_i(bo-1 downto 0),s=>s_l(0),f=>x_p_i_1_s);	
	end generate;
	
	gen_layer_1_s: if layers=1 generate
		p <= x_p_i_1_s;
	end generate;
	--------------------------
	
	-------- Layer 2 ---------
	gen_layer_2: if layers>1 generate
		x_p_i_1 <= (bo+1 downto bo=>'0') & x_p_i_1_s;
		u_m_2 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i_1(bo+1 downto 2), b=>x_p_i_1(bo-1 downto 0),s=>s_l(1),f=>x_p_i_2_s);			
	end generate;
	
	gen_layer_2_s: if layers=2 generate
		p <= x_p_i_2_s;
	end generate;
	--------------------------
	
	-------- Layer 3 ---------
	gen_layer_3: if layers>2 generate
		x_p_i_2 <= (bo+3 downto bo=>'0') & x_p_i_2_s;
		u_m_3 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i_2(bo+3 downto 4), b=>x_p_i_2(bo-1 downto 0),	s=>s_l(2), f=>x_p_i_3_s);		
	end generate;
		
	gen_layer_3_s: if layers=3 generate
		p <= x_p_i_3_s;
	end generate;
	--------------------------
	
	-------- Layer 4 ---------
	gen_layer_4: if layers>3 generate
		x_p_i_3 <= (bo+7 downto bo=>'0') & x_p_i_3_s;
		u_m_4 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i_3(bo+7 downto 8), b=>x_p_i_3(bo-1 downto 0),	s=>s_l(3), f=>x_p_i_4_s);		
	end generate;
	
	gen_layer_4_s: if layers=4 generate
		p <= x_p_i_4_s;
	end generate;
	--------------------------
	
	-------- Layer 5 ---------
	gen_layer_5: if layers>4 generate
		x_p_i_4 <= (bo+15 downto bo=>'0') & x_p_i_4_s;
		u_m_5 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i_4(bo+15 downto 16), b=>x_p_i_4(bo-1 downto 0),	s=>s_l(4), f=>x_p_i_5_s);		
	end generate;
	
	gen_layer_5_s: if layers=5 generate
		p <= x_p_i_5_s;
	end generate;
	--------------------------
	
	-------- Layer 6 ---------
	gen_layer_6: if layers>5 generate
		x_p_i_5 <= (bo+31 downto bo=>'0') & x_p_i_5_s;
		u_m_6 : mux_2_1 generic map (n=>bo) port map (a=>x_p_i_5(bo+31 downto 32), b=>x_p_i_5(bo-1 downto 0),	s=>s_l(5), f=>x_p_i_6_s);			
	end generate;
	
	gen_layer_6_s: if layers=6 generate
		p <= x_p_i_6_s;
	end generate;
	--------------------------

	--x_p_i_6 <= (bo+19 downto bo=>'0') & x_p_i_6_s;
end Behavioral; 


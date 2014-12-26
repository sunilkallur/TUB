--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:16:09 01/29/2014
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/Floating_Mul/TB_F_Mul_23x23.vhd
-- Project Name:  Floating_Mul
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: F_Mul_23x23
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_F_Mul_23x23 IS
END TB_F_Mul_23x23;
 
ARCHITECTURE behavior OF TB_F_Mul_23x23 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT F_Mul_23x23
    PORT(
         a : IN  std_logic_vector(22 downto 0);
         b : IN  std_logic_vector(22 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         P : OUT  std_logic_vector(22 downto 0);
			zero: OUT STD_LOGIC;
			sign: OUT STD_LOGIC;
			overflow: OUT STD_LOGIC);
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(22 downto 0) := (others => '0');
   signal b : std_logic_vector(22 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal P : std_logic_vector(22 downto 0);
   signal sign : std_logic;
	signal overflow : std_logic;
	signal zero : std_logic;
	
   -- Clock period definitions
   constant clk_period : time := 15 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: F_Mul_23x23 PORT MAP (
          a => a,
          b => b,
          clk => clk,
          rst => rst,
          P => P,
			 zero => zero,
			 overflow => overflow,
			 sign => sign
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	
		rst <= '1';
		
		wait for 100 ns;	
		a<= "10111100110000000000000";
		b<= "00111100110000000000000";
		rst<= '0';
		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		a<= "01000000100100000000000";
		b<= "01000000111000000000000";
		rst<= '0';
		
		wait for 100 ns;	
		a<= "01000000100000000000000";
		b<= "01000000100000000000000";
		rst<= '0';
		
		wait for 100 ns;	
		a<= "01000000110000000000000";
		b<= "01000000110000000000000";
		rst<= '0';
	
		wait for 100 ns;	
		a<= "00000000100000000000001";
		b<= "00111110000000000000001";
		rst<= '0';
		
		wait for 100 ns;	
		a<= "01111110111111111111111";
		b<= "01111110111111111111111";
		rst<= '0';
		
      wait;
   end process;

END;

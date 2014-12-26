--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:16:41 01/18/2014
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/Multiplier/TB_ppg_radix4_16x16bit.vhd
-- Project Name:  Multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ppg_radix4_16x16bit
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
 
ENTITY TB_ppg_radix4_16x16bit IS
END TB_ppg_radix4_16x16bit;
 
ARCHITECTURE behavior OF TB_ppg_radix4_16x16bit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ppg_radix4_16x16bit
    PORT(
         a_i_minus_1 : IN  std_logic;
         a_i : IN  std_logic;
         a_i_plus_1 : IN  std_logic;
         b : IN  std_logic_vector(15 downto 0);
         P_i : OUT  std_logic_vector(16 downto 0);
         T : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a_i_minus_1 : std_logic := '0';
   signal a_i : std_logic := '0';
   signal a_i_plus_1 : std_logic := '0';
   signal b : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal P_i : std_logic_vector(16 downto 0);
   signal T : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ppg_radix4_16x16bit PORT MAP (
          a_i_minus_1 => a_i_minus_1,
          a_i => a_i,
          a_i_plus_1 => a_i_plus_1,
          b => b,
          P_i => P_i,
          T => T
        );



   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      a_i_minus_1 <= '0';
		a_i <= '0';
		a_i_plus_1 <= '0';
		b<= "0000111100001111";
      -- insert stimulus here 
		wait for 100 ns;	

      a_i_minus_1 <= '1';
		a_i <= '0';
		a_i_plus_1 <= '0';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '0';
		a_i <= '1';
		a_i_plus_1 <= '0';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '1';
		a_i <= '1';
		a_i_plus_1 <= '0';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '0';
		a_i <= '0';
		a_i_plus_1 <= '1';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '1';
		a_i <= '0';
		a_i_plus_1 <= '1';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '0';
		a_i <= '1';
		a_i_plus_1 <= '1';
		b<= "0000111100001111";
		
		wait for 100 ns;	

      a_i_minus_1 <= '1';
		a_i <= '1';
		a_i_plus_1 <= '1';
		b<= "0000111100001111";
		
      wait;
   end process;

END;

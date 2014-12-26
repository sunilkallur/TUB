--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:37:15 12/14/2013
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/MA_Filter/CSA_TB.vhd
-- Project Name:  MA_Filter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CSA
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
 
ENTITY CSA_TB IS
END CSA_TB;
 
ARCHITECTURE behavior OF CSA_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CSA
    PORT(
         a : IN  std_logic_vector(14 downto 0);
         b : IN  std_logic_vector(14 downto 0);
         c : IN  std_logic_vector(14 downto 0);
         d : IN  std_logic_vector(14 downto 0);
         S : OUT  std_logic_vector(14 downto 0);
         Cry : OUT  std_logic_vector(14 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(14 downto 0) := (others => '0');
   signal b : std_logic_vector(14 downto 0) := (others => '0');
   signal c : std_logic_vector(14 downto 0) := (others => '0');
   signal d : std_logic_vector(14 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(14 downto 0);
   signal Cry : std_logic_vector(14 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CSA PORT MAP (
          a => a,
          b => b,
          c => c,
          d => d,
          S => S,
          Cry => Cry
        );

   -- Clock process definitions
   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		a<= "100000000000000";
		b<= "000000000000000";
		c<= "000000000000000";
		d<= "000000000000000";
		
		wait for 100 ns;	
		
		a<= "000000000000100";
		b<= "000000000000000";
		c<= "000000000000000";
		d<= "000000000000000";
		
		 wait for 100 ns;	
		
		a<= "000000000000001";
		b<= "000000000000001";
		c<= "000000000000001";
		d<= "000000000000001";
		
		wait for 100 ns;	
		
		a<= "000000000000100";
		b<= "000000000000100";
		c<= "000000000000100";
		d<= "000000000000100";
		
		 wait for 100 ns;	
		
		a<= "111111111111111";
		b<= "111111111111111";
		c<= "111111111111111";
		d<= "111111111111111";
		
		wait for 100 ns;	
		
		a<= "000000000100101";
		b<= "000000000100101";
		c<= "000000000100101";
		d<= "000000000100101";
		
		
		

      --wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

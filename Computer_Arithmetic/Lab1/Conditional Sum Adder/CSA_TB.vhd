--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:31:30 11/14/2013
-- Design Name:   
-- Module Name:   /afs/tu-berlin.de/home/k/kallur_sunil/irb-ubuntu/Condition_SA/CSA_TB.vhd
-- Project Name:  Condition_SA
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
         a : IN  std_logic_vector(7 downto 0);
         b : IN  std_logic_vector(7 downto 0);
         s : OUT  std_logic_vector(7 downto 0);
         c : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(7 downto 0) := (others => '0');
   signal b : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal s : std_logic_vector(7 downto 0);
   signal c : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CSA PORT MAP (
          a => a,
          b => b,
          s => s,
          c => c
        );

   
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
 
      wait for 100 ns;
      a <= "00000000" ;
      b <= "00000000" ;
     
		
      wait for 100 ns;
      a <= "00000001" ;
      b <= "00000000" ;
     
 
      wait for 100 ns;
      a <= "00000010" ;
      b <= "00000000" ;
   

      wait for 100 ns;
      a <= "11111111" ;
      b <= "11110011" ;

		
		
      -- insert stimulus here 

      wait;
   end process;

END;

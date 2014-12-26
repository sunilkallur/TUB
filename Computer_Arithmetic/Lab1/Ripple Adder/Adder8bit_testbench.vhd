--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:40:19 11/06/2013
-- Design Name:   
-- Module Name:   /afs/tu-berlin.de/home/k/kallur_sunil/irb-ubuntu/sunil_eitict/Adder8bit_testbench.vhd
-- Project Name:  sunil_eitict
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Adder8bit
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
 
ENTITY Adder8bit_testbench IS
END Adder8bit_testbench;
 
ARCHITECTURE behavior OF Adder8bit_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Adder8bit
    PORT(
         a : IN  std_logic_vector(7 downto 0);
         b : IN  std_logic_vector(7 downto 0);
         c : IN  std_logic;
         s : OUT  std_logic_vector(7 downto 0);
         co : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(7 downto 0) := (others => '0');
   signal b : std_logic_vector(7 downto 0) := (others => '0');
   signal c : std_logic := '0';

 	--Outputs
   signal s : std_logic_vector(7 downto 0);
   signal co : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Adder8bit PORT MAP (
          a => a,
          b => b,
          c => c,
          s => s,
          co => co
        );

  
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      a <= "00000000" ;
      b <= "00000000" ;
      c <= '0' ;
		
      wait for 100 ns;
      a <= "00000001" ;
      b <= "00000000" ;
      c <= '0' ;
 
      wait for 100 ns;
      a <= "00000010" ;
      b <= "00000000" ;
      c <= '0' ; 

      wait for 100 ns;
      a <= "00001111" ;
      b <= "11110000" ;
      c <= '0' ; 

      wait for 100 ns;
      a <= "11111111" ;
      b <= "11110000" ;
      c <= '0' ; 

      wait for 100 ns;
      a <= "00001111" ;
      b <= "11110000" ;
      c <= '0' ; 		

      wait for 10 us;
		
		a<= "00001111" ;
      b<= "11110000" ;
      c<= '1' ; 

      wait for 100 ns;
		
		a<= "11111111" ;
      b<= "11111111" ;
      c<= '1' ; 


      -- insert stimulus here 

      wait;
   end process;

END;

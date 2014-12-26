--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:52:44 11/20/2013
-- Design Name:   
-- Module Name:   /afs/tu-berlin.de/home/k/kallur_sunil/irb-ubuntu/CLA/CL_Adder_TestBench.vhd
-- Project Name:  CLA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CL_Adder
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
 
ENTITY CL_Adder_TestBench IS
END CL_Adder_TestBench;
 
ARCHITECTURE behavior OF CL_Adder_TestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CL_Adder
    PORT(
         x : IN  std_logic_vector(7 downto 0);
         y : IN  std_logic_vector(7 downto 0);
         cin : IN  std_logic;
         s : OUT  std_logic_vector(7 downto 0);
         cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal cin : std_logic := '0';

 	--Outputs
   signal s : std_logic_vector(7 downto 0);
   signal cout : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CL_Adder PORT MAP (
          x => x,
          y => y,
          cin => cin,
          s => s,
          cout => cout
        );

   -- Clock process definitions
   stim_proc :process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      x <= "00000000" ;
      y <= "00000000" ;
      cin <= '0' ;
		
      wait for 100 ns;
      x <= "00000001" ;
      y <= "00000000" ;
      cin <= '0' ;
 
      wait for 100 ns;
      x <= "00000010" ;
      y <= "00000000" ;
      cin <= '0' ; 

      wait for 100 ns;
      x <= "00001111" ;
      y <= "11110000" ;
      cin <= '0' ; 

      wait for 100 ns;
      x <= "11111111" ;
      y <= "11110000" ;
      cin <= '0' ; 

      wait for 100 ns;
      x <= "00001111" ;
      y <= "11110000" ;
      cin <= '0' ; 		

      wait for 10 us;
		
		x<= "00001111" ;
      y<= "11110000" ;
      cin<= '1' ; 

      wait for 100 ns;
		
		x<= "11111111" ;
      y<= "11111111" ;
      cin<= '1' ; 


      -- insert stimulus here 

      wait;
   end process;

END;

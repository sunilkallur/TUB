--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:56:34 12/14/2013
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/MA_Filter/CSA_16IN_TB.vhd
-- Project Name:  MA_Filter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CSA_16IN
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
use work.CS_Adder_Package.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CSA_16IN_TB IS
END CSA_16IN_TB;
 
ARCHITECTURE behavior OF CSA_16IN_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CSA_16IN
    PORT(
         a : IN  input_array;
         S : OUT  std_logic_vector(14 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : input_array;

 	--Outputs
   signal S : std_logic_vector(14 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CSA_16IN PORT MAP (
          a => a,
          S => S
        );

   -- Clock process definitions
  
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 2000 ns;	
		
		a(0)(10 downto 0)<="11111111111";
		u1: for i in 1 to 15 loop
				
		   a(i)(10 downto 0) <= "00000000000";
		end loop u1;
		--a(15)(14 downto 0)<="111111111111111";
		
		wait for 1000 ns;	
		
		a(0)(10 downto 0)<= "00001111111";
		u2: for i in 0 to 15 loop
		    a(i)(10 downto 0) <= "00000001111";
		end loop u2;
		
		wait for 1600 ns;
		
		a(0)(10 downto 0)<= "11111111111";
		u3: for i in 1 to 15 loop
		    a(i)(10 downto 0) <= "11111111111";
		end loop u3;
		
			 
		
		
		

      --wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

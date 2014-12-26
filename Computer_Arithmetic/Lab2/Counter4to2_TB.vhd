--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:27:49 12/14/2013
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/MA_Filter/Counter4to2_TB.vhd
-- Project Name:  MA_Filter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Counter4to2
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
 
ENTITY Counter4to2_TB IS
END Counter4to2_TB;
 
ARCHITECTURE behavior OF Counter4to2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counter4to2
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         c : IN  std_logic;
         d : IN  std_logic;
         ti : IN  std_logic;
         S : OUT  std_logic;
         Cry : OUT  std_logic;
         t0 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c : std_logic := '0';
   signal d : std_logic := '0';
   signal ti : std_logic := '0';

 	--Outputs
   signal S : std_logic;
   signal Cry : std_logic;
   signal t0 : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  -- constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counter4to2 PORT MAP (
          a => a,
          b => b,
          c => c,
          d => d,
          ti => ti,
          S => S,
          Cry => Cry,
          t0 => t0
        );

   -- Clock process definitions
  
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		a<= '1';
		b<= '1';
		c<='1';
		d<='1';
		ti<='0';

      wait for 100ns;
		
		a<= '0';
		b<= '0';
		c<='0';
		d<='1';
		ti<='0';
		
		wait for 100ns;
		
		a<= '1';
		b<= '0';
		c<='0';
		d<='1';
		ti<='0';
		
		wait for 100ns;
		
		a<= '0';
		b<= '0';
		c<='0';
		d<='0';
		ti<='0';
		
		wait for 100ns;
		
		a<= '1';
		b<= '1';
		c<='1';
		d<='0';
		ti<='0';
		
		wait for 100ns;
		
		a<= '0';
		b<= '1';
		c<='1';
		d<='1';
		ti<='0';
      -- insert stimulus here 

      wait;
   end process;

END;

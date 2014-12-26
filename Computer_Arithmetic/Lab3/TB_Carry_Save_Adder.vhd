--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:30:11 01/18/2014
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/Multiplier/TB_Carry_Save_Adder.vhd
-- Project Name:  Multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Carry_Save_Adder
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
use work.in_vector.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_Carry_Save_Adder IS
END TB_Carry_Save_Adder;
 
ARCHITECTURE behavior OF TB_Carry_Save_Adder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Carry_Save_Adder
    PORT(
         PP : IN  partial_products;
         T : IN  std_logic_vector(7 downto 0);
         P : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PP : partial_products;
   signal T : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal P : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Carry_Save_Adder PORT MAP (
          PP => PP,
          T => T,
          P => P
        );

   -- Clock process definitions
   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		PP(0) <= "00000000000000001";
		PP(1) <= "00000000000000001";
		PP(2) <= "00000000000000001";
		PP(3) <= "00000000000000001";
		PP(4) <= "00000000000000001";
		PP(5) <= "00000000000000001";
		PP(6) <= "00000000000000001";
		PP(7) <= "00000000000000001";
		T     <= "00000000"; 

     

      -- insert stimulus here 

      wait;
   end process;

END;

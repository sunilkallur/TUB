--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:56:04 01/18/2014
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/Multiplier/TB_Mul_16x16.vhd
-- Project Name:  Multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Mul_16x16
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
 
ENTITY TB_Mul_16x16 IS
END TB_Mul_16x16;
 
ARCHITECTURE behavior OF TB_Mul_16x16 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Mul_16x16
    PORT(
         a : IN  std_logic_vector(15 downto 0);
         b : IN  std_logic_vector(15 downto 0);
         P : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(15 downto 0) := (others => '0');
   signal b : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal P : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Mul_16x16 PORT MAP (
          a => a,
          b => b,
          P => P
        );

   -- Clock process definitions
   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		a<= "0000000000000000";
		b<= "0000000000000000";
		
		 wait for 100 ns;	
		a<= "0000000000000001";
		b<= "0000000000000001";
		
		 
		
		 wait for 100 ns;	
		a<= "0000000000000100";
		b<= "0000000000000100";
		
		 wait for 100 ns;	
		a<= "1000000000000001";
		b<= "1000000000000001";
		
		wait for 100 ns;	
		a<= "1111111111111111";
		b<= "1111111111111111";
		
		wait for 100 ns;	
		a<= "0000000000000001";
		b<= "0000000000000001";
		
		wait for 100 ns;	
		a<= "0000000000000010";
		b<= "0000000000000010";
		
		wait for 100 ns;	
		a<= "0000000000001000";
		b<= "0011011100010010";
		
		wait for 100 ns;	
		a<= "0101011000000000";
		b<= "0000000001110000";
		
		wait for 100 ns;	
		a<= "0101001110001111";
		b<= "1100011100101111";
		
		
      wait;
   end process;

END;

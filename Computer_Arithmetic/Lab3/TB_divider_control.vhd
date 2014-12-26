--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:03:35 01/19/2014
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/ISE_DS/Multiplier/TB_divider_control.vhd
-- Project Name:  Multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: divider_control
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
 
ENTITY TB_divider_control IS
END TB_divider_control;
 
ARCHITECTURE behavior OF TB_divider_control IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT divider_control
    PORT(
         clk : IN  std_logic;
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         rst : IN  std_logic;
         quotient : OUT  std_logic_vector(15 downto 0);
			--start : out std_logic;
		--	 start :  inout NATURAL RANGE 0 TO 10;
      --	 start : inout STD_LOGIC_VECTOR ( 3 downto 0 );
		--	 Fx,Nx,Dx : inout std_logic_vector(15 downto 0);
			 done : out std_logic
			--state : inout state_type
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal rst : std_logic := '0';
	

 	--Outputs
   signal quotient : std_logic_vector(15 downto 0);
--	signal start : STD_LOGIC_VECTOR ( 3 downto 0 );
--	signal Fx,Nx,Dx: std_logic_vector(15 downto 0);
	signal done : std_logic;
	--signal state : state_type;

   -- Clock period definitions
   constant clk_period : time := 22 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: divider_control PORT MAP (
          clk => clk,
          A => A,
          B => B,
          rst => rst,
          quotient => quotient,
--			 start => start,
--			 Fx =>Fx,
--			 Nx => Nx,
--			 Dx => Dx,
			 done => done
			-- state => state_type
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
      -- hold reset state for 100 ns.
   
	   

		--wait for 1000 ns;	
	  

      A<= "0000000100000000";
		B<= "0000000100000000";
		rst<= '1';

	--	wait for 1000 ns;	
	   wait until (done = '1');
		
      A<= "0000000100000000";
		B<= "0000000100000000";
		rst<= '0';
		
		--wait for 1000 ns;	
		--wait until (done'event and done = '0');
		wait until (done = '1');
		

      A<= "0000001000000000";
		B<= "0000000100000000";
		rst<= '0';
	
		
		--wait for 1000 ns;	
		wait until done ='1';

      A<= "0000010000000000";
		B<= "0000000100000000";
		rst<= '0';
		
		--wait for 1000 ns;	
		wait until done ='1';

      A<= "0000100000000000";
		B<= "0000000100000000";
		rst<= '0';
      -- insert stimulus here 
		
		--wait for 1000 ns;	
		wait until done ='1';

      A<= "0101011000000000";
		B<= "0000011100000000";
		rst<= '0';

		wait until done ='1';
		
		A<= "0000011100000000";
		B<= "0000010000000000";
		rst<= '0';
		
		wait until done ='1';
		
		A<= "0000011100000000";
		B<= "0000011100000000";
		rst<= '1';
		
      wait;
   end process;

END;

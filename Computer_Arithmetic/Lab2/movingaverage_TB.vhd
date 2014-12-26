LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use CS_Adder_Package.all;


use std.textio.all; -- This enables file IO during simulation
 
ENTITY movingaverage_tb IS
END movingaverage_tb;
 
ARCHITECTURE behavior OF movingaverage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT movingaverage is
    PORT(
         sin : IN  std_logic_vector(10 downto 0);
         clk : IN  std_logic;
         sout : OUT  std_logic_vector(10 downto 0);
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sin : std_logic_vector(10 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal sout : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: movingaverage PORT MAP (
          sin => sin,
          clk => clk,
          sout => sout,
          rst => rst
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
	
	file INPUT_FILE : text open read_mode is "input.txt";
	file OUTPUT_FILE : text open write_mode is "output.txt";
	
	variable input_line : LINE;
	variable output_line: LINE;
	variable str : bit_vector(10 downto 0) ;
	variable b : boolean;
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		
		for i in 1 to 1000 loop -- read 1000 samples
			
			wait until clk'event and clk = '1'; -- wait until the positive edge of the clk
		
			readline (INPUT_FILE,input_line); -- read one line from the input file
			read(input_line,str);				 -- parse that line for a 10 bit vector
			sin <= to_stdlogicvector(str);	 -- convert to std_logic_vector type
			
			write(output_line,to_bitvector(sout)); -- write the result to the output line
			writeline(output_file,output_line);		-- write the line to the output file
		
		end loop;	
		      
   end process;

END;

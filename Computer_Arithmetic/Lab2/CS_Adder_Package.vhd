--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package CS_Adder_Package is


type input_array is array (15 downto 0)of std_logic_vector(10 downto 0);
type CSA_Array is array (3 downto 0)of std_logic_vector(10 downto 0);
type SE_CSA_Array is array (3 downto 0)of std_logic_vector(14 downto 0);
type output_array is array (15 downto 0)of std_logic_vector(14 downto 0);
type se_array is array(15 downto 0)of std_logic_vector(14 downto 0);

subtype vao is std_logic_vector(14 downto 0);

function sl(input: vao) return vao;
  
-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end CS_Adder_Package;

package body CS_Adder_Package is


function sl(input: vao) return vao is 
variable k: std_logic_vector(14 downto 0);
	begin
		for i in 14 downto 1 loop
		k(i):=input(i-1);
	end loop;
	k(0):= '0';
	return k;
end sl;

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end CS_Adder_Package;

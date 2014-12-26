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

package in_vector is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;

type partial_products is array(7 downto 0) of std_logic_vector (16 downto 0);
--type state_type is (state_1, state_2, state_3, state_4,state_5,state_6,state_7,state_8,state_9,state_10); 
type state_type is (state_1, state_2, state_3,state_4); 
subtype vao is std_logic_vector(15 downto 0);
function reciprocal(input: vao) return vao;
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

end in_vector;

package body in_vector is

function reciprocal(input: vao) return vao is 
variable k: std_logic_vector(15 downto 0):= "0000000000000000";
variable rec_complete:std_logic:= '0';
	begin
	
		for i in 14 downto 0 loop
			if ((input(i) = '1') and (rec_complete = '0')) then
			
				k(14-i) := '1';
				rec_complete := '1';
			
			end if;	
		end loop;
	
	return k;
end reciprocal;

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
 
end in_vector;

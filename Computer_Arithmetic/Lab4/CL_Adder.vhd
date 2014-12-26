----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:44:03 11/20/2013 
-- Design Name: 
-- Module Name:    CL_Adder - Structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CL_Adder is
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           y : in  STD_LOGIC_VECTOR (7 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (7 downto 0);
           cout : out  STD_LOGIC);
end CL_Adder;

architecture Structural of CL_Adder is

component Carry_Generate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           g : out  STD_LOGIC;
           p : out  STD_LOGIC);
end Component;

Component CLA_Stage is
    Port ( g : in  STD_LOGIC;
           p : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           cout : out  STD_LOGIC);
end Component;

Component Summation is
    Port ( --g : in  STD_LOGIC;
           p : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC
           --c : out  STD_LOGIC
			  );
end Component;

signal cg,cp:std_logic_vector(7 downto 0);
signal c0:std_logic_vector(8 downto 0);

begin

c0(0) <= cin;

u1 : for i in 0 to 7 generate
    u2 : Carry_Generate port map (x(i),y(i),cg(i),cp(i));
	 u3 : CLA_Stage port map (cg(i),cp(i),c0(i),c0(i+1));
	 u4 :	Summation port map (cp(i),c0(i),s(i));
	 end generate u1;
	 
cout<= c0(8);
 
end Structural;


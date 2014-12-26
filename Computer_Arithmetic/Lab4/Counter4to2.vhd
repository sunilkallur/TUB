----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:13 12/11/2013 
-- Design Name: 
-- Module Name:    Counter4to2 - Structural 
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
--use CS_Adder_Package.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter4to2 is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           d : in  STD_LOGIC;
			  ti : in STD_LOGIC;
           S : out  STD_LOGIC;
           Cry : out  STD_LOGIC;
			  t0: out STD_LOGIC);
end Counter4to2;

architecture Structural of Counter4to2 is

Component FullAdder is
Port ( a : in STD_LOGIC;
b : in STD_LOGIC;
c : in STD_LOGIC;
s : out STD_LOGIC;
co : out STD_LOGIC);
end Component;

signal m: std_logic;

begin

u1: FullAdder Port map(a,b,c,m,t0);
u2: FullAdder Port map(m,d,ti,S,Cry);

end Structural;


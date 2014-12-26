----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:58 01/12/2014 
-- Design Name: 
-- Module Name:    Mul_16x16 - Structural 
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
use work.in_vector.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mul_16x16 is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           P : out  STD_LOGIC_VECTOR (31 downto 0));
end Mul_16x16;

architecture Structural of Mul_16x16 is

signal pp:partial_products;
signal T:std_logic_vector(7 downto 0);

Component ppg_radix4_16x16bit is
    Port ( a_i_minus_1 : in  STD_LOGIC;
           a_i : in  STD_LOGIC;
           a_i_plus_1 : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           P_i : out  STD_LOGIC_VECTOR (16 downto 0);
			  T   : out std_logic);
end Component;


Component Carry_Save_Adder is
    Port ( PP : in  partial_products;
           T : in  STD_LOGIC_VECTOR (7 downto 0);
           P : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

begin

U0:ppg_radix4_16x16bit port map ('0',a(0),a(1),b,PP(0),T(0));
U1:ppg_radix4_16x16bit port map (a(1),a(2),a(3),b,PP(1),T(1));
U2:ppg_radix4_16x16bit port map (a(3),a(4),a(5),b,PP(2),T(2));
U3:ppg_radix4_16x16bit port map (a(5),a(6),a(7),b,PP(3),T(3));
U4:ppg_radix4_16x16bit port map (a(7),a(8),a(9),b,PP(4),T(4));
U5:ppg_radix4_16x16bit port map (a(9),a(10),a(11),b,PP(5),T(5));
U6:ppg_radix4_16x16bit port map (a(11),a(12),a(13),b,PP(6),T(6));
U7:ppg_radix4_16x16bit port map (a(13),a(14),a(15),b,PP(7),T(7));


U8: Carry_Save_Adder port map (PP,T,P);
	

end Structural;


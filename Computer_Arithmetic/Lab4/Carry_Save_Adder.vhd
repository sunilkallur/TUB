----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:07:09 01/12/2014 
-- Design Name: 
-- Module Name:    Carry_Save_Adder - Behavioral 
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
USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE IEEE.numeric_std.all;
use work.in_vector.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Carry_Save_Adder is
    Port ( PP : in  partial_products;
           T : in  STD_LOGIC_VECTOR (7 downto 0);
           P : out  STD_LOGIC_VECTOR (31 downto 0));
end Carry_Save_Adder;

architecture Structural of Carry_Save_Adder is

signal S0,S1:std_logic_vector(23 downto 0);
signal C0:std_logic_vector(22 downto 0);
signal C1:std_logic_vector(21 downto 0);
signal t0,t1 : std_logic_vector (16 downto 0);
signal t2:std_logic_vector(15 downto 0);
signal S2: std_logic_vector(31 downto 0);
signal C2: std_logic_vector(29 downto 0);
signal S: std_logic_vector(31 downto 0);
signal C: std_logic_vector(29 downto 0);
signal cout,i1,i2,i3,i4,i5,i6:std_logic;

Component CL_Adder is
    Port ( x : in  STD_LOGIC_VECTOR (28 downto 0);
           y : in  STD_LOGIC_VECTOR (28 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (28 downto 0);
           cout : out  STD_LOGIC);
end Component;


Component Counter4to2 is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           d : in  STD_LOGIC;
			  ti : in STD_LOGIC;
           S : out  STD_LOGIC;
           Cry : out  STD_LOGIC;
			  t0: out STD_LOGIC);
end Component;

Component HA is
port(
a : in STD_LOGIC;
b : in STD_LOGIC;
s : out STD_LOGIC;
co : out STD_LOGIC);

end Component;


Component FullAdder is
Port ( a : in STD_LOGIC;
b : in STD_LOGIC;
c : in STD_LOGIC;
s : out STD_LOGIC;
co : out STD_LOGIC);
end Component;


begin

U0: HA port map(PP(0)(0),T(0),S0(0),C0(0));
S0(1) <= PP(0)(1);
U1: FullAdder port map(PP(0)(2),PP(1)(0),T(1),S0(2),C0(1));
U2: HA port map(PP(0)(3),PP(1)(1),S0(3),C0(2));

--Series of 4:2 counters for addign PP0 to PP3

U3:Counter4to2 port map (PP(0)(4),PP(1)(2),PP(2)(0),T(2),'0',S0(4),C0(3),t0(0)); 
U4:Counter4to2 port map (PP(0)(5),PP(1)(3),PP(2)(1),'0',t0(0),S0(5),C0(4),t0(1)); 

U5:Counter4to2 port map (PP(0)(6),PP(1)(4),PP(2)(2),PP(3)(0),t0(1),S0(6),C0(5),t0(2));
U6:Counter4to2 port map (PP(0)(7),PP(1)(5),PP(2)(3),PP(3)(1),t0(2),S0(7),C0(6),t0(3));
U7:Counter4to2 port map (PP(0)(8),PP(1)(6),PP(2)(4),PP(3)(2),t0(3),S0(8),C0(7),t0(4));
U8:Counter4to2 port map (PP(0)(9),PP(1)(7),PP(2)(5),PP(3)(3),t0(4),S0(9),C0(8),t0(5));
U9:Counter4to2 port map (PP(0)(10),PP(1)(8),PP(2)(6),PP(3)(4),t0(5),S0(10),C0(9),t0(6));
U10:Counter4to2 port map (PP(0)(11),PP(1)(9),PP(2)(7),PP(3)(5),t0(6),S0(11),C0(10),t0(7));
U11:Counter4to2 port map (PP(0)(12),PP(1)(10),PP(2)(8),PP(3)(6),t0(7),S0(12),C0(11),t0(8));
U12:Counter4to2 port map (PP(0)(13),PP(1)(11),PP(2)(9),PP(3)(7),t0(8),S0(13),C0(12),t0(9));
U13:Counter4to2 port map (PP(0)(14),PP(1)(12),PP(2)(10),PP(3)(8),t0(9),S0(14),C0(13),t0(10));
U14:Counter4to2 port map (PP(0)(15),PP(1)(13),PP(2)(11),PP(3)(9),t0(10),S0(15),C0(14),t0(11));
U15:Counter4to2 port map (PP(0)(16),PP(1)(14),PP(2)(12),PP(3)(10),t0(11),S0(16),C0(15),t0(12));

U16:Counter4to2 port map (PP(0)(16),PP(1)(15),PP(2)(13),PP(3)(11),t0(12),S0(17),C0(16),t0(13));
U17:Counter4to2 port map (PP(0)(16),PP(1)(16),PP(2)(14),PP(3)(12),t0(13),S0(18),C0(17),t0(14));
i1 <= (not PP(0)(16));
i2 <= (not PP(1)(16));
U18:Counter4to2 port map (i1,i2,PP(2)(15),PP(3)(13),t0(14),S0(19),C0(18),t0(15));
U19:Counter4to2 port map ('0','1',PP(2)(16),PP(3)(14),t0(15),S0(20),C0(19),t0(16)); 
i3 <= (not PP(2)(16));
U20:FullAdder port map (i3,PP(3)(15),t0(16),S0(21),C0(20));
U21:HA port map ('1',PP(3)(16),S0(22),C0(21));
S0(23) <= not PP(3)(16);
C0(22) <= '1';

--Adding PP4 to PP7

V0: HA port map(PP(4)(0),T(4),S1(0),C1(0));
S1(1) <= PP(4)(1);
V1: FullAdder port map(PP(4)(2),PP(5)(0),T(5),S1(2),C1(1));
V2: HA port map(PP(4)(3),PP(5)(1),S1(3),C1(2));


--Series of 4:2 counters for addign PP4 to PP7

V3:Counter4to2 port map (PP(4)(4),PP(5)(2),PP(6)(0),T(6),'0',S1(4),C1(3),t1(0)); 
V4:Counter4to2 port map (PP(4)(5),PP(5)(3),PP(6)(1),'0',t1(0),S1(5),C1(4),t1(1)); 

V5:Counter4to2 port map (PP(4)(6),PP(5)(4),PP(6)(2),PP(7)(0),t1(1),S1(6),C1(5),t1(2));
V6:Counter4to2 port map (PP(4)(7),PP(5)(5),PP(6)(3),PP(7)(1),t1(2),S1(7),C1(6),t1(3));
V7:Counter4to2 port map (PP(4)(8),PP(5)(6),PP(6)(4),PP(7)(2),t1(3),S1(8),C1(7),t1(4));
V8:Counter4to2 port map (PP(4)(9),PP(5)(7),PP(6)(5),PP(7)(3),t1(4),S1(9),C1(8),t1(5));
V9:Counter4to2 port map (PP(4)(10),PP(5)(8),PP(6)(6),PP(7)(4),t1(5),S1(10),C1(9),t1(6));
V10:Counter4to2 port map (PP(4)(11),PP(5)(9),PP(6)(7),PP(7)(5),t1(6),S1(11),C1(10),t1(7));
V11:Counter4to2 port map (PP(4)(12),PP(5)(10),PP(6)(8),PP(7)(6),t1(7),S1(12),C1(11),t1(8));
V12:Counter4to2 port map (PP(4)(13),PP(5)(11),PP(6)(9),PP(7)(7),t1(8),S1(13),C1(12),t1(9));
V13:Counter4to2 port map (PP(4)(14),PP(5)(12),PP(6)(10),PP(7)(8),t1(9),S1(14),C1(13),t1(10));
V14:Counter4to2 port map (PP(4)(15),PP(5)(13),PP(6)(11),PP(7)(9),t1(10),S1(15),C1(14),t1(11));
V15:Counter4to2 port map (PP(4)(16),PP(5)(14),PP(6)(12),PP(7)(10),t1(11),S1(16),C1(15),t1(12));

i4<= not PP(4)(16);
V16:Counter4to2 port map (i4,PP(5)(15),PP(6)(13),PP(7)(11),t1(12),S1(17),C1(16),t1(13));
V17:Counter4to2 port map ('1',PP(5)(16),PP(6)(14),PP(7)(12),t1(13),S1(18),C1(17),t1(14));

i5 <= (not PP(5)(16));
V18:Counter4to2 port map ('0',i5,PP(6)(15),PP(7)(13),t1(14),S1(19),C1(18),t1(15));
V19:Counter4to2 port map ('0','1',PP(6)(16),PP(7)(14),t1(15),S1(20),C1(19),t1(16)); 
i6 <= (not PP(6)(16));
V20:FullAdder port map (i6,PP(7)(15),t1(16),S1(21),C1(20));
V21:HA port map ('1',PP(7)(16),S1(22),C1(21));
S1(23)<= not PP(7)(16);

--Adding S0,C0,S1 and C1

S2(0) <= S0(0);
P0:HA port map (S0(1),C0(0),S2(1),C2(0));
S2(2) <= S0(2);
P1:HA port map (S0(3),C0(1),S2(3),C2(1));
P2:HA port map (S0(4),C0(2),S2(4),C2(2));
P3:HA port map (S0(5),C0(3),S2(5),C2(3));

P4:FullAdder port map(S0(6),C0(4),T(3),S2(6),C2(4));
P5:HA port map (S0(7),C0(5),S2(7),C2(5));
P6:FullAdder port map(S0(8),C0(6),S1(0),S2(8),C2(6));

P7:Counter4to2 port map(S0(9),C0(7),S1(1),C1(0),'0',S2(9),C2(7),t2(0));
P8:Counter4to2 port map(S0(10),C0(8),S1(2),'0',t2(0),S2(10),C2(8),t2(1));

--S0 from 11 to 23

PPP: for i in 1 to 13 generate
		P100: Counter4to2 port map(S0(i+10),C0(i+8),S1(i+2),C1(i),t2(i),S2(i+10),C2(i+8),t2(i+1));
  end generate PPP;
  
P9:Counter4to2 port map('0',C0(22),S1(16),C1(14),t2(14),S2(24),C2(22),t2(15));
P10:FullAdder port map(S1(17),C1(15),t2(15),S2(25),C2(23));

PPHA: for i in 1 to 6 generate
		HAdder: HA port map(S1(i+17),C1(i+15),S2(i+25),C2(i+23));
	end generate PPHA;

--calculating S and C

S(0) <= S2(0);
S(1)<= S2(1);
k0: HA port map (S2(2),C2(0),S(2),C(0));

S(13 downto 3) <= S2(13 downto 3);
C(10 downto 1) <= C2(10 downto 1);

C(11) <= '0';

k1: FullAdder port map(S2(14),C2(11),T(7),S(14),C(12));

--HA to add 

G1: for i in 1 to 17 generate
		KK :HA port map (S2(i+14),C2(i+11),S(i+14),C(i+12));
	end generate G1;

-- Adder for final 2 rows

P(2 downto 0) <= S(2 downto 0);

--Addr:CL_Adder port map (S(31 downto 3),C(28 downto 0),'0',P(31 downto 3),cout);
P(31 downto 3) <= S(31 downto 3) + C(28 downto 0);

end Structural;


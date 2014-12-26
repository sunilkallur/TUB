----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:23 01/12/2014 
-- Design Name: 
-- Module Name:    divider_control - Behavioral 
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
use IEEE.math_real.all;
USE IEEE.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.in_vector.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity divider_control is
    Port ( clk : in  STD_LOGIC;
           A : in  STD_LOGIC_VECTOR (15 downto 0);
			  B : in  STD_LOGIC_VECTOR (15 downto 0);	
           rst : in  STD_LOGIC;
			  quotient : out  STD_LOGIC_VECTOR (15 downto 0);
	--	     start :  inout NATURAL RANGE 0 TO 10;
			  done : out std_logic
	--		  Fx,Nx,Dx : inout std_logic_vector(15 downto 0)
			  
           );
end divider_control;

architecture Behavioral of divider_control is

component CL_Adder_16 is
    Port ( x : in  STD_LOGIC_VECTOR (15 downto 0);
           y : in  STD_LOGIC_VECTOR (15 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (15 downto 0);
           cout : out  STD_LOGIC);
end Component;

Component Mul_16x16 is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           P : out  STD_LOGIC_VECTOR (31 downto 0));
end Component;

	
   signal state,next_state : state_type; 
	signal F,N,D,quotientx,Fx,Nx,Dx: std_logic_vector(15 downto 0);
--	signal F,N,D,quotientx: std_logic_vector(15 downto 0);
	signal Fni,Fdi: std_logic_vector(31 downto 0); 
	signal RFni,RFdi,complement_RFDi,RFi: std_logic_vector(15 downto 0);
	signal startx : Natural range 0 to 10;
	signal cout1,cout2 : std_logic;
	signal done_i : std_logic := '0';
	SIGNAL const2 : STD_LOGIC_VECTOR(15 DOWNTO 0) ;
	--signal rec_complete :std_logic:= '0';
	signal B_rec:std_logic_vector(15 downto 0):="0000000000000000";
	
   --Declare internal signals for all outputs of the state-machine
   --signal output_i : STD_LOGIC_VECTOR (1 downto 0);  -- example output signal
   
 
begin

	const2<="0000001000000000";

	--process for synchronization
   SYNC_PROC: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (rst = '1') then
            state <= state_1;
				Fx <= "0000000000000000";
				Nx <= "0000000000000000";
				Dx <= "0000000000000000";
		--		start <= 0;
				quotient <= "0000000000000000";
				done <= '1'; 
				
           
         else
			
            state <= next_state;
				Fx <= F;
				Nx <= N;
				Dx <= D;
		--		start <= startx;
				quotient <= quotientx;
				done <= done_i;
           
         end if;        
      end if;
   end process;
	
 
   
   OUTPUT_DECODE: process (clk,state)
	variable rec_complete :std_logic:= '0';
   begin
      
      case (state) is
			
			
			when state_1 =>
					
				
				done_i <= '0';
		--		startx <= 1;
				
					
					IF B(14) = '1' THEN
						B_rec(14 downto 0) <= "000000000000001";
					
					ELSIF B(14) = '0' AND B(13) = '1' THEN
						B_rec(14 downto 0) <= "000000000000010";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '1' THEN
						B_rec(14 downto 0) <= "000000000000100";			  
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '1' THEN
						B_rec(14 downto 0) <= "000000000001000";		
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '1' THEN
						B_rec(14 downto 0) <= "000000000010000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '1' THEN
						B_rec(14 downto 0) <= "000000000100000";		  
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '1' THEN
						B_rec(14 downto 0) <= "000000001000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '1' THEN
						B_rec(14 downto 0) <= "000000010000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '1' THEN
						B_rec(14 downto 0) <= "000000100000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '1' THEN
						B_rec(14 downto 0) <= "000001000000000";	
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '1' THEN
						B_rec(14 downto 0) <= "000010000000000";	  
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '0' AND B(3) = '1' THEN
						B_rec(14 downto 0) <= "000100000000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '0' AND B(3) = '0' AND B(2) = '1' THEN
						B_rec(14 downto 0) <= "001000000000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '0' AND B(3) = '0' AND B(2) = '0' AND B(1) = '1'  THEN
						B_rec(14 downto 0) <= "010000000000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '0' AND B(3) = '0' AND B(2) = '0' AND B(1) = '0' AND B(0) = '1'  THEN
						B_rec(14 downto 0) <= "100000000000000";
					
					ELSIF B(14) = '0' AND B(13) = '0' AND B(12) = '0' AND B(11) = '0' AND B(10) = '0' AND B(9) = '0' AND B(8) = '0' AND B(7) = '0' AND B(6) = '0' AND B(5) = '0' AND B(4) = '0' AND B(3) = '0' AND B(2) = '0' AND B(1) = '0' AND B(0) = '0'  THEN
						B_rec(14 downto 0) <= "000000000000000";
					
					END IF;  

	

					B_rec(15) <=  B(15);
					F <= "0000000000000000";
					N <= "0000000000000000";
					D <= "0000000000000000";
					F <= B_rec;
				
					
			when state_2 =>
					
					F <= B_rec;
					N <=  A;
					D <= B;
			--		startx <= 2;
					done_i <= '0';
					
										
			when state_3 =>   
					
					F <= RFi;
					N <= RFni;
					D <= RFdi;
				--	startx <= (start + 1);
					done_i <= '0';
			
					
			when state_4 =>
						
				--	startx <= 10;
					done_i <= '1';
						
			end case;
			
   end process;
	
	
	mul1:Mul_16x16 port map(Fx,Dx,FDi);
	mul2:Mul_16x16 port map(Fx,Nx,Fni);
	
	
	--Rounding
	RFDi(14 downto 0) <= FDi (22 downto 8);
	RFDi(15) <= FDi(31);
	RFni(14 downto 0) <= Fni (22 downto 8);
	RFni(15) <= Fni(31);
	
	RFi <= std_logic_vector(((const2) - RFDi));
	
	
	
	--complement_RFDi <= not RFDi;
	--Adder_Qo : CL_Adder_16 port map(complement_RFDi,"0000001000000000",'1',RFi,cout1);
	--Adder_Q1 : CL_Adder_16 port map(I_RFi,"0000000100000000",'0',RFi,cout2);
	
	
   NEXT_STATE_DECODE: process (clk,state)
   begin
      
      next_state <= state;  --default is to stay in current state
      
      case (state) is
         when state_1 =>
               next_state <= state_2;
					
			 when state_2 =>
               next_state <= state_3;
           
         when state_3 =>
				if (Dx(7 downto 1) = "1111111") then
            	next_state <= state_4;
						quotientx <=RFni;
					--	done_i <= '1';
				else
					next_state <= state_3;
				end if;
				
         when state_4 =>
				
					next_state <= state_1;
	
      end case;      
   end process;
end Behavioral;

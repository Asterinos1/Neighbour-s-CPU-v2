----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:25 04/10/2023	
-- Design Name: 
-- Module Name:    shift_ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_ALU is

	Port (A : in  STD_LOGIC_VECTOR (31 downto 0);
			B : in  STD_LOGIC_VECTOR (31 downto 0);
			Op : in  STD_LOGIC_VECTOR (3 downto 0);
			Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
			Zero : out  STD_LOGIC;
			Cout : out  STD_LOGIC;
			Ovf : out  STD_LOGIC);
end shift_ALU;

architecture Behavioral of shift_ALU is

begin
	--zero, cout, ovf not affected.	
	Ovf  <= '0' ;
	Cout <= '0' ;
	Zero <= '0' ;
	
	Out_1 <=  (STD_LOGIC_VECTOR(shift_right(Signed(A),1))) when Op = "1000" else --arithmetic shift right
				(STD_LOGIC_VECTOR(shift_right(unsigned(A),1))) when Op = "1001" else --right shift by 1
				(STD_LOGIC_VECTOR(shift_left(unsigned(A),1))) when Op = "1010" else --left shift by 1
				(STD_LOGIC_VECTOR(rotate_left(unsigned(A),1))) when Op = "1100" else --rotate left
				(STD_LOGIC_VECTOR(rotate_right(unsigned(A),1))) when Op = "1101";   --rotate right
				     
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:24:36 04/10/2023  
-- Design Name: 
-- Module Name:    logical_ALU - Behavioral 
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

entity logical_ALU is
	Port (A : in  STD_LOGIC_VECTOR (31 downto 0);
			B : in  STD_LOGIC_VECTOR (31 downto 0);
			Op : in  STD_LOGIC_VECTOR (3 downto 0);
			Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
			Zero : out  STD_LOGIC;
			Cout : out  STD_LOGIC;
			Ovf : out  STD_LOGIC);      
end logical_ALU;

architecture Behavioral of logical_ALU is

begin
	--zero. cout, ovf aren't affected.
	Ovf  <= '0' ;
	Cout <= '0' ;
	Zero <= '0' ;
	
	Out_1 <= (A and B) when Op = "0010" else
				(A or B) when Op = "0011" else
				(not A) when Op = "0100";	
end Behavioral;

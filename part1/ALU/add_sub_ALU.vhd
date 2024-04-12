----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:27 04/10/2023
-- Design Name: 
-- Module Name:    add_sub_ALU - Behavioral 
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
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity add_sub_ALU is
    Port( A : in  STD_LOGIC_VECTOR (31 downto 0);
        B : in  STD_LOGIC_VECTOR (31 downto 0);
        Op : in  STD_LOGIC_VECTOR (3 downto 0);
        Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
	     Zero : out  STD_LOGIC;
        Cout : out  STD_LOGIC;
        Ovf : out  STD_LOGIC);
end add_sub_ALU;

architecture Behavioral of add_sub_ALU is
SIGNAL temp : STD_LOGIC_VECTOR (32 downto 0); -- vector for calculate Cout. is 33 bit and in msb hold the Cout
--singla to check for Carry out(33rd bit =(MSB)) .

begin
	--We add an extra 0 bit in the front 
	--to avoid problems when doing addition/subtraction.
	
	temp <=((A(31) & A) + (B(31) & B)) when Op = "0000" else
			((B(31) & A) - (B(31) & B)) when Op = "0001";

	--Ovf when 1) sign of sum different from the A,B sign.
	--         2) sign of A and B are different but reuslt has the sign of B.
	Ovf <= '1' when ((Op = "0000") AND (A(31) = B(31)) AND ( temp(31) /= A(31))) else
			'1' when ((Op = "0001") AND (A(31)/= B(31)) AND ( temp(31) = B(31))) else
			'0';

	--If sum/diff = 0 , zero=1 else zero=0.
	Zero <='1' when temp = "000000000000000000000000000000000" else
			 '0'; 
	
	--finaly add Carry out.
	Cout <= temp(32);
	Out_1 <= temp(31 downto 0); --return the result to Out_1

end Behavioral;


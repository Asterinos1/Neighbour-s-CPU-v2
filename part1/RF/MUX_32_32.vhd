----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:06:57 04/18/2023 
-- Design Name: 
-- Module Name:    MUX_32_32 - Behavioral 
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
library WORK;
use WORK.ARRAY_IO_32.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_32_32 is
    Port ( M_in_32 : arr_io;
           M_out : out  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC_VECTOR (4 downto 0));
end MUX_32_32;

architecture Behavioral of MUX_32_32 is

begin
	M_out <= M_in_32(0) when Sel = b"00000" else
				M_in_32(1) when Sel = b"00001" else
				M_in_32(2) when Sel = b"00010" else
				M_in_32(3) when Sel = b"00011" else
				M_in_32(4) when Sel = b"00100" else
				M_in_32(5) when Sel = b"00101" else
				M_in_32(6) when Sel = b"00110" else
				M_in_32(7) when Sel = b"00111" else
				M_in_32(8) when Sel = b"01000" else
				M_in_32(9) when Sel = b"01001" else
				M_in_32(10) when Sel = b"01010" else
				M_in_32(11) when Sel = b"01011" else
				M_in_32(12) when Sel = b"01100" else
				M_in_32(13) when Sel = b"01101" else
				M_in_32(14) when Sel = b"01110" else
				M_in_32(15) when Sel = b"01111" else
				M_in_32(16) when Sel = b"10000" else
				M_in_32(17) when Sel = b"10001" else
				M_in_32(18) when Sel = b"10010" else
				M_in_32(19) when Sel = b"10011" else
				M_in_32(20) when Sel = b"10100" else
				M_in_32(21) when Sel = b"10101" else
				M_in_32(22) when Sel = b"10110" else
				M_in_32(23) when Sel = b"10111" else
				M_in_32(24) when Sel = b"11000" else
				M_in_32(25) when Sel = b"11001" else
				M_in_32(26) when Sel = b"11010" else
				M_in_32(27) when Sel = b"11011" else
				M_in_32(28) when Sel = b"11100" else
				M_in_32(29) when Sel = b"11101" else
				M_in_32(30) when Sel = b"11110" else
				M_in_32(31);
				 
end Behavioral;


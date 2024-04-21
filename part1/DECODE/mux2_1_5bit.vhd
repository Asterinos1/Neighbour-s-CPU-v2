library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
library work;
use work.small_matrix.all;

entity mux2_1_5bit is
    Port ( input : in  SMALL_MATRIX(0 to 1);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end mux2_1_5bit;

architecture Behavioral of mux2_1_5bit is
begin
	output <= input(0) when sel='0' else input(1);
end Behavioral;


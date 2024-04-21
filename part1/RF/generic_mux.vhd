library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.matrices.all;

entity generic_mux is
	Port ( input : in  MATRIX (0 to 31);
           sel : in  integer range 0 to 31;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end generic_mux;

architecture Behavioral of generic_mux is

begin
	output <= input(sel);
end Behavioral;


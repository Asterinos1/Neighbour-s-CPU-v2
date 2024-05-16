library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Using our custom array of vectors package.
use work.arr_vector32.all;

entity reg_mux is
    Port ( input : in  arr_v32 (0 to 31);
           sel : in  integer range 0 to 31;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end reg_mux;

architecture Behavioral of reg_mux is

begin
	-- This module represents the mux that takes as input the 32 registers.
	-- Depending on the sel signal which is an integer
	-- We assing to the output the vector of the input array of vectors
	-- as the output of the reg_mux
	output <= input(sel);

end Behavioral;


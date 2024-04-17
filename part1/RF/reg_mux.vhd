library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.matrices.all;

entity reg_mux is
	port(
		reg_in: in MATRIX(0 to 31);
		sel: in integer range 0 to 31;
		reg_out: out std_logic_vector(31 downto 0)
		);
end reg_mux;

architecture Behavioral of reg_mux is

begin
	reg_out <= reg_in(sel);
end Behavioral;


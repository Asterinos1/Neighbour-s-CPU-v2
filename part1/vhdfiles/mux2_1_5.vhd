library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.arr_vector5.all;

entity mux2_1_5 is
    Port ( input : in  arr_v5(0 to 1);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
end mux2_1_5;

architecture Behavioral of mux2_1_5 is
begin
	output <=input(0) when sel='0' else input(1);
end Behavioral;


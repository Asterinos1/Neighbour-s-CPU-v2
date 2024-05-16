library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.arr_vector32.all;

-- This is the multiplexer that according to PC_Sel,
-- it decides between  the PC+4 or PC+ 4 + Immed
entity mux2_1 is	
	Port ( input : in  	arr_v32(0 to 1);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end mux2_1;

architecture Behavioral of mux2_1 is
begin
	output <= input(0) when sel='0' else input(1);
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity out_mux is
    Port ( input_1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input_2 : in  STD_LOGIC_VECTOR (31 downto 0);
           sel_2 : in  STD_LOGIC;
           output_2 : out  STD_LOGIC_VECTOR (31 downto 0));
end out_mux;

architecture Behavioral of out_mux is

begin
	process(input_1, input_2, sel_2)
	begin
		-- Depending on the sel signal select between DataIn of RF
		-- and the output of the registers's muxs
		if sel_2 = '0' then
			output_2 <=input_1;
		else
			output_2 <=input_2;
		end if;
	end process;
end Behavioral;


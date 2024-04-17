library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Getting package 'matrices' from the work library.
use work.matrices.all;

entity mux_out is
    Port ( in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           in2 : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end mux_out;

architecture Behavioral of mux_out is

begin
	process(in1, in2, sel)
	begin
		if sel = '0' then
			output <= in1;
		else
			output <= in2;
		end if;
	end process;
end Behavioral;


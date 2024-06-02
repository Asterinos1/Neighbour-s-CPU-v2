library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- The equal comperator module replaces the function
-- previously used in the control.vhd
entity equal_comparator_32_bit is
port(	in1			: in std_logic_vector(31 downto 0); 		
		in2			: in std_logic_vector(31 downto 0);
		equal_flag	: out std_logic
		);
end equal_comparator_32_bit;
architecture behavioral of equal_comparator_32_bit is 
	signal in1Value	: integer;
	signal in2Value	: integer; 
begin
	-- Convert the content of each 32bit vector to ints
	in1Value <= to_integer(unsigned(in1(31 downto 0)));
	in2Value <= to_integer(unsigned(in2(31 downto 0)));
	-- if the contents of the registers are equal, we set the flag to 1 else 0
	equal_flag <= '1' when (in1Value = in2Value) else '0';
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity se_m4_adder is
    Port ( in_mul : in  STD_LOGIC_VECTOR (31 downto 0);
           in_add : in  STD_LOGIC_VECTOR (31 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0));
end se_m4_adder;

architecture Behavioral of se_m4_adder is
	signal temp_se: std_logic_vector(31 downto 0):=(others=>'0');
	signal temp_result:std_logic_vector(34 downto 0):=(others=>'0');
begin
	-- first we have to sing extend in_mull
	temp_se <= std_logic_vector(resize(signed(in_mul),32));
	-- then multiply by 4 and add the immediate value
	temp_result <= temp_se * "100";
	result <= (in_add) + temp_result(31 downto 0); --  in case of overflow

end Behavioral;


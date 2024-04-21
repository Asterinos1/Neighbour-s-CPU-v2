library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    Port ( A : in  STD_LOGIC_VECTOR (4 downto 0);
           X : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder;

architecture Behavioral of decoder is

begin

	decode: process(A)
	begin
	
		X <= X"00000000";
		X(conv_integer(A)) <= '1';
		
	end process;

end Behavioral;


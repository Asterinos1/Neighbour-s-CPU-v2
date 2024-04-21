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
		-- The above statements are "squeezed" into the following line so that the after statement can be applied correctly.
		-- However this may cause problems with synthesizability, due to non static index assignment. If this happens, comment
		-- the following line out and uncomment the 2 lines above.
		--X <= (conv_integer(A) => '1', others => '0');	-- 1 at input position, 0 everywhere else.
	end process;

end Behavioral;


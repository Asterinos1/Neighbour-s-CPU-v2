library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    Port ( decIn : in  STD_LOGIC_VECTOR (4 downto 0);
           decOut : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder;

architecture Behavioral of decoder is

begin

	decode: process(decIn)
	begin
	
		decOut <= X"00000000";  --First reset the decoder's output
		decOut(conv_integer(decIn)) <= '1';
		
	end process;

end Behavioral;


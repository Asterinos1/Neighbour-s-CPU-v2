library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder_5_32 is
    Port ( input : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder_5_32;

architecture Behavioral of decoder_5_32 is

begin
	process(input)
	begin
		-- First convert output to zeros
		output<=X"00000000";
		-- Then according to conv_integer(input), flip  that specific bit to 1
		-- and get the corresponding 32 bit ouput (one hot encoding method)
		output(conv_integer(input))<='1';
	end process;

end Behavioral;


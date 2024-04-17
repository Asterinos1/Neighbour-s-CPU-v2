library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    Port ( dec_in : in  STD_LOGIC_VECTOR (4 downto 0);
           dec_out : out  STD_LOGIC_VECTOR (31 downto 0));
end decoder;

architecture Behavioral of decoder is

begin
	process(dec_in)
    begin
        -- Initializing output to 0 , turn every bit to 0
        dec_out <= (others => '0');
        -- Use conv_integer to convert std_logic_vector to integer
		  -- Using unsigned since we're expecting a value from 0 to 31 non negative
        dec_out(conv_integer(dec_in)) <= '1';
    end process;
end Behavioral;
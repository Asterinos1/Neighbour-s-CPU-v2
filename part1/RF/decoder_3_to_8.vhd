----------------------------------------------------------------------------------
-- Company: 
-- EngDineer: 
-- 
-- Create Date:    19:39:40 04/16/2023 
-- Design Name: 
-- Module Name:    decoder_3_to_8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the followDing library declaration if usDing
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the followDing library declaration if DinstantiatDing
-- any XilDinx primitives Din this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_3_to_8 is
    Port ( Din : in  STD_LOGIC_VECTOR (2 downto 0);
			  En : in STD_LOGIC;	
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end decoder_3_to_8;

architecture Behavioral of decoder_3_to_8 is
	
	component decoder_2_to_4
		port (din : in STD_LOGIC_VECTOR (1 downto 0);
				en : in STD_LOGIC;
				dout : out STD_LOGIC_VECTOR (3 downto 0)
				);
	end component;
	
	signal dec_intern : STD_LOGIC_VECTOR (1 downto 0);

	begin
	
		D0: decoder_2_to_4
			port map ( din => Din(1 downto 0),
						  en => dec_intern(0),
						  dout => Dout(3 downto 0)
						  );
						  
		D1: decoder_2_to_4
			port map ( din => Din(1 downto 0),
						  en => dec_intern(1),
						  dout => Dout(7 downto 4)
						  );

		process(Din, en)
		begin
			if en = '1' then
				if Din(2) = '0' then
					dec_intern <= b"01";
				else 
					dec_intern <= b"10";
				end if;
			else
				Dout <= b"0000_0000";
				
			end if;
		end process;	
	end Behavioral;


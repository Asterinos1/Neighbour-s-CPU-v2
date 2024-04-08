----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:20:51 04/14/2023 
-- Design Name: 
-- Module Name:    decoder_5_to_32 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_5_to_32 is
    Port ( Din : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0));
end decoder_5_to_32;

architecture structural of decoder_5_to_32 is
	--Subcomponents for the 5 to 32 decoder
	component decoder_3_to_8
		port (din : in STD_LOGIC_VECTOR (2 downto 0);
				dout : out STD_LOGIC_VECTOR (7 downto 0);
				en : in STD_LOGIC
				);
	end component;
	
	component decoder_2_to_4
		port (din : in STD_LOGIC_VECTOR (1 downto 0);
				dout : out STD_LOGIC_VECTOR (3 downto 0);
				en : in STD_LOGIC
				);
	end component;

	signal dec_intern : STD_LOGIC_VECTOR (3 downto 0);

	begin 
		
		D0 : decoder_2_to_4
			port map ( din => Din(4 downto 3),
						  dout => dec_intern,
						  en => '1'
						);
							
		D1 : decoder_3_to_8
			port map (din => Din(2 downto 0),
						 en => dec_intern(0),
						 dout => Dout(7 downto 0)
						 );
						 
		D2 : decoder_3_to_8
			port map (din => Din(2 downto 0),
						 en => dec_intern(1),
						 dout => Dout(15 downto 8)
						 );
						 
		D3 : decoder_3_to_8
			port map (din => Din(2 downto 0),
						 en => dec_intern(2),
						 dout => Dout(23 downto 16)
						 );
						 
		D4 : decoder_3_to_8
			port map (din => Din(2 downto 0),
						 en => dec_intern(3),
						 dout => Dout(31 downto 24)
						 );
	
		
	
end structural;


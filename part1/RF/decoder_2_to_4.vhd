----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:11:12 04/16/2023 
-- Design Name: 
-- Module Name:    decoder_2_to_4 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_2_to_4 is
    Port ( Din : in  STD_LOGIC_VECTOR (1 downto 0);
		     En : in STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (3 downto 0));
end decoder_2_to_4;

architecture Behavioral of decoder_2_to_4 is

begin
	process(En, Din)
	begin
		case En is
			when '1' =>
				if Din = "00" then
					Dout <= b"0001";
					
				elsif Din = "01" then
					Dout <= b"0010";
					
				elsif Din = b"10" then
					Dout <= b"0100";
					
				else
					Dout <= b"1000";
				end if;
			when others =>
				Dout <= "0000";
		end case;
	end process;
end Behavioral;


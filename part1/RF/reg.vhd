----------------------------------------------------------------------------------
-- Module Name:    register - Behavioral 
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

entity reg is
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           RST : in  STD_LOGIC;
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end reg;

	
architecture Behavioral of reg is

		signal temp : STD_LOGIC_VECTOR (31 downto 0);

begin

-- Design taken from lab material "flip-flop with Q" and adapted 
-- Synchronous RST Register with Enable signal

	process (CLK,WE,RST,Datain)
	begin
		if rising_edge(CLK) then
			if 	RST='1' 	then	temp <= (others => '0');	-- reset is "active high"
			elsif WE='1' 	then	temp <= Datain;				-- elsif because WE and RST should not be on at the same time
			else temp <= temp;
			end if;
		end if;    
	end process;

		Dataout <= temp;
end Behavioral;


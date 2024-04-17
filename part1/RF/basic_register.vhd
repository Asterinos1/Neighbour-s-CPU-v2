library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity basic_register is
    Port ( DataIN : in  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           DataOUT : out  STD_LOGIC_VECTOR (31 downto 0));
end basic_register;

architecture Behavioral of basic_register is

begin
	process(CLK, WE, DataIN, RST)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				DataOUT <= b"0000_0000_0000_0000_0000_0000_0000_0000";
			else 
				if WE = '1' then
					DataOUT <= DataIN;
				end if;
			end if;			
		end if;
	end process;
end Behavioral;


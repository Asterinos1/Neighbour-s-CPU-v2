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

	process (CLK,WE,RST,Datain)
	begin
		if rising_edge(CLK) then
			if 	RST='1' 	then	temp <= (others => '0');	
			elsif WE='1' 	then	temp <= Datain;				
			else temp <= temp;
			end if;
		end if;    
	end process;

		Dataout <= temp;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity basic_register is
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           RST : in  STD_LOGIC;
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end basic_register;

architecture Behavioral of basic_register is
	-- temp signal to handle the content of the register
	signal temp: std_logic_vector(31 downto 0);
begin
	process(CLK, WE, Datain, RST)
	begin
		if rising_edge(CLK) then
			-- Reset the content of the register
			if RST='1' then 
				temp <= b"0000_0000_0000_0000_0000_0000_0000_0000";
			-- if we=1, save datain to temp as content of the register
			elsif WE='1' 
				then temp<= Datain;
			-- else do nothing
			else temp <= temp; 
			end if;
		end if;
	end process;
	
	-- move the register content to the output
	Dataout<=temp;
end Behavioral;


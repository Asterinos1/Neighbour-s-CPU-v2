library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compare_module is
	Port ( 
		inp : in STD_LOGIC_VECTOR (4 downto 0);
		inp2 : in  STD_LOGIC_VECTOR (4 downto 0);
		we : in std_logic;
		outp: out std_logic
		 );
end compare_module;


architecture Behavioral of compare_module is

	signal temp: std_logic; 

begin
	process(inp,inp2,we)	
	begin
		if(we='1') then	
			if (inp = inp2)  then
				temp<= '1';
			else
				temp<= '0';
			end if;
		else
			temp <= '0';
		end if;	
		
	end process;
		 
		outp <= temp;
			
end Behavioral;

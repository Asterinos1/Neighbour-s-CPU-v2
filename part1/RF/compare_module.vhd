library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compare_module is
    Port ( ard_in : in  STD_LOGIC_VECTOR (4 downto 0);
           awr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           WE : in  STD_LOGIC;
           cmp_out : out  STD_LOGIC);
end compare_module;

architecture Behavioral of compare is

	signal temp: std_logic; -- temp signal to hanlde the output

begin
	process(ard_in, awr_in, WE)
	begin
		if(WE='1') then
			if(ard_in = awr_in) then
				temp<='1'; -- Set output to '1' if inputs are equal
			else
				temp<='0'; -- Set output to '0' if inputs are not equal
			end if;
		else
			temp<='0'; -- Set output to '0' if comparison is disabled
		end if;	
	end process;
	
	cmp_out<=temp; --finally assing temp to output
	
end Behavioral;


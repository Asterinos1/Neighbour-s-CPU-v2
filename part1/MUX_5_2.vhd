----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:19 04/27/2024 
-- Design Name: 
-- Module Name:    MUX_5_2 - Behavioral 
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

entity MUX_5_2 is
    Port ( In0 : in  STD_LOGIC_VECTOR (4 downto 0);
           In1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  Sel : in STD_LOGIC;
           M_Out : out  STD_LOGIC_VECTOR (4 downto 0));
end MUX_5_2;

architecture Behavioral of MUX_5_2 is

begin

	process(Sel, In0, In1)
	begin
		if (Sel = '0') then
			M_Out <= In0;
		else 
			M_Out <= In1;
		end if;
	end process;

end Behavioral;


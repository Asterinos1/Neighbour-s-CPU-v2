----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:19 04/27/2024 
-- Design Name: 
-- Module Name:    Instr_ext - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instr_ext is
	Port ( Opcode : in STD_LOGIC_VECTOR (1 downto 0);
			 Instr : in  STD_LOGIC_VECTOR (15 downto 0);
          Immed : out  STD_LOGIC_VECTOR (31 downto 0));
end Instr_ext;

architecture Behavioral of Instr_ext is

begin

	process(Opcode, Instr)
	begin
		case Opcode is
			when "00" =>
				Immed <= resize(Instr, Immed'length);				
		end case;
	end process;

end Behavioral;


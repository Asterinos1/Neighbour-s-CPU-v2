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
use IEEE.NUMERIC_STD.ALL; -- Properly included for arithmetic operations

entity Instr_ext is
    Port ( Opcode : in STD_LOGIC_VECTOR (1 downto 0);
           Instr : in  STD_LOGIC_VECTOR (15 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0));
end Instr_ext;

architecture Behavioral of Instr_ext is
	signal temp: STD_LOGIC_VECTOR(31 downto 0);
begin
    process(Opcode, Instr)
    begin
        case Opcode is
            when "00" => -- Simple zerofill, no shifting
					temp <= x"0000" & Instr;
				when "01" => -- zerofill with shift left
					temp <=  Instr & x"0000";
				when "10" => --se without shift
               temp(15 downto 0) <= Instr;
					temp(31 downto 16) <= (others => Instr(15));
				when "11" => --se with shift
					temp(15 downto 0) <= Instr;
					temp(31 downto 16)<= (others => Instr(15));
				when others => --default stays dones nothing
					null;
        end case;
    end process;
	
	--temporary fix
	Immed <= (temp(29 downto 0) & "00") when opcode="11" else temp;
end Behavioral;


----------------------------------------------------------------------------------
-- Module Name:    generic_mux - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.matrices.all;


entity s_mux is
    Generic (n: integer := 1); -- selector size
    Port ( 
        input_1 : in  STD_LOGIC_VECTOR (31 downto 0);
        input_2 : in  STD_LOGIC_VECTOR (31 downto 0);
        sel_2: in  std_logic;
        output_2 : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end s_mux;

architecture Behavioral of s_mux is
begin
    process(input_1,input_2,sel_2)	

    begin	
        if sel_2 = '0' then
            output_2 <= input_1;
        else
            output_2 <= input_2;
        end if;
    end process;
end Behavioral;
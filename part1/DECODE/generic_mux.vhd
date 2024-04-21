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
use work.matrices.all;

entity generic_mux is

	Generic (n: integer := 5); -- selector size

	Port ( input : in  MATRIX (0 to (2**n)-1);
           sel : in  integer range 0 to 2**n-1;
           output : out  STD_LOGIC_VECTOR (m-1 downto 0));
end generic_mux;

architecture Behavioral of generic_mux is

begin

	output <= input(sel);

end Behavioral;


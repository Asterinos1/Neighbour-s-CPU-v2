library IEEE;
use IEEE.STD_LOGIC_1164.all;

package matrices is
	type MATRIX is ARRAY(NATURAL RANGE<>) OF STD_LOGIC_VECTOR(31 downto 0);
end package matrices;

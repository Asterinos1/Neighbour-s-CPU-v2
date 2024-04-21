library IEEE;
use IEEE.STD_LOGIC_1164.all;

package small_matrix is
	type SMALL_MATRIX is ARRAY(NATURAL RANGE<>) OF STD_LOGIC_VECTOR(4 downto 0);
end package small_matrix;


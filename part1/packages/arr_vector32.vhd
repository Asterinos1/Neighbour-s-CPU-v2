library IEEE;
use IEEE.STD_LOGIC_1164.all;

package arr_vector32 is
	type arr_v32 is ARRAY(NATURAL RANGE<>) OF STD_LOGIC_VECTOR(31 downto 0);
end package arr_vector32;
--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package matrices is

	constant m: integer := 32;	-- the size of the matrix's elements
	type MATRIX is ARRAY(NATURAL RANGE<>) OF STD_LOGIC_VECTOR(m-1 downto 0);

end package matrices;


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

package array_io_32 is

	type arr_io is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
 
end array_io_32;

package body array_io_32 is

end array_io_32;
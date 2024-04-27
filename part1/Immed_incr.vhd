----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:47:57 04/23/2024 
-- Design Name: 
-- Module Name:    Immed_incr - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Immed_incr is
    Port ( Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           incr : in  STD_LOGIC_VECTOR (31 downto 0);
           res : out  STD_LOGIC_VECTOR (31 downto 0));
end Immed_incr;

architecture Behavioral of Immed_incr is

	signal sign_extended: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal multiplication_result: STD_LOGIC_VECTOR (34 downto 0):= (others => '0');

begin
	
	sign_extended <= std_logic_vector(resize(signed(incr), 32));
	multiplication_result <= sign_extended * "100";
	res <= (Immed) + multiplication_result(31 downto 0);

end Behavioral;


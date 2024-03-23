----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:28 03/23/2024 
-- Design Name: 
-- Module Name:    memory_controller - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_controller is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           AddrWrite : in  STD_LOGIC_VECTOR (4 downto 0);
           AddrRead : in  STD_LOGIC_VECTOR (4 downto 0);
           Write : in  STD_LOGIC;
           Read : in  STD_LOGIC;
           NumberIN : in  STD_LOGIC_VECTOR (15 downto 0);
           NumberOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           Valid : out  STD_LOGIC);
end memory_controller;

architecture Behavioral of memory_controller is

begin


end Behavioral;


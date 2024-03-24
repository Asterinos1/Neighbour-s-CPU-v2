----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:56:17 03/23/2024 
-- Design Name: 
-- Module Name:    top_entity_module - Behavioral 
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

entity top_entity_module is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           AddrWrite : in  STD_LOGIC_VECTOR (4 downto 0);
           AddrRead : in  STD_LOGIC_VECTOR (4 downto 0);
           WriteF : in  STD_LOGIC;
           ReadF : in  STD_LOGIC;
           NumberIN : in  STD_LOGIC_VECTOR (15 downto 0);
           NumberOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           Valid : out  STD_LOGIC);
end top_entity_module;

architecture Behavioral of top_entity_module is

	component memory_controller is
		Port( CLK,RST,Wf,Rf: in std_logic;
				AddrW, AddrR: in std_logic_vector(4 downto 0);
				WEf: out std_logic_vector(0 downto 0);
				AddrOUT: out std_logic_vector(4 downto 0)
				);
	end component;
	
	component memory is 
		Port ( rsta, clka : in std_logic;
					wea: in std_logic_vector(0 downto 0); -- In MEM vhd this flag is set as vector of 1 bit for smrsn idk
					addra: in std_logic_vector(4 downto 0);
					dina: in std_logic_vector(15 downto 0);
					douta : out std_logic_vector(15 downto 0)
				);
	end component;
	
	signal we_s : std_logic_vector(0 downto 0);
	signal addr_s : std_logic_vector (4 downto 0);
	
begin

	u1: memory_controller Port Map(CLK => CLK,
						RST => RST,
						AddrW => AddrWrite,
						AddrR => AddrRead,
						Wf => WriteF,
						Rf => ReadF);
						
	u2: memory Port Map (clka => CLK,
						rsta => RST,
						douta => NumberOUT,
						dina => NumberIN,
						wea => we_s,
						addra => addr_s);
						
	Valid <= ReadF;

	

end Behavioral;

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
				WEf, val: out std_logic;
				AddrOUT: out std_logic_vector(4 downto 0)
				);
	end component;
	

COMPONENT memory
  PORT (
    a : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    qspo_rst : IN STD_LOGIC;
    qspo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;
	
	signal we_s : std_logic;
	signal addr_s : std_logic_vector (4 downto 0);
	
begin

	u2: memory Port Map (clk => CLK,
						qspo_rst => RST,
						qspo => NumberOUT,
						d => NumberIN,
						we => we_s,
						a => addr_s);


	u1: memory_controller Port Map(CLK => CLK,
						RST => RST,
						AddrW => AddrWrite,
						AddrR => AddrRead,
						Wf => WriteF,
						Rf => ReadF,
						AddrOUT => addr_s,
						WEf => we_s,
						val => Valid);
						

	

end Behavioral;

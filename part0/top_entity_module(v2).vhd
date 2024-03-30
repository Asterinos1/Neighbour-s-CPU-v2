library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_entity_module is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           WriteFlag : in  STD_LOGIC;
           ReadFlag : in  STD_LOGIC;
           NumberIN : in  STD_LOGIC_VECTOR (15 downto 0);
           NumberOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           AddrRead : in  STD_LOGIC_VECTOR (4 downto 0);
           AddrWrite : in  STD_LOGIC_VECTOR (4 downto 0);
           Valid : out  STD_LOGIC);
end top_entity_module;

architecture Behavioral of top_entity_module is
	component memory_controller is
	port ( Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           WriteF : in  STD_LOGIC;
           ReadF : in  STD_LOGIC;
           AddrR, AddrW : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : in  STD_LOGIC_VECTOR (15 downto 0);
           AddrOUT : out  STD_LOGIC_VECTOR (4 downto 0);
           DataOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           WEf : out  STD_LOGIC);
	end component;
	
	component memory is
	port(a : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			 d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 clk : IN STD_LOGIC;
			 we : IN STD_LOGIC;
			 spo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
	
	--Signals to connect memory_controller ouputs to memory.
	signal addr_out: std_logic_vector(4 downto 0);
	signaL data_out: std_logic_vector(15 downto 0);
	signal wef_s: std_logic;
begin

	u1: memory_controller Port Map(
		Data=>NumberIN,
		AddrR=> AddrRead,
		AddrW=> AddrWrite,
		Clk=>CLK,
		Rst=>RST,
		WriteF =>WriteFlag,
		ReadF =>ReadFlag,
		AddrOUT=>addr_out,
		DataOUT=>data_out,
		WEf=> wef_s
	);
	
	u2: memory Port Map(
		a=>addr_out,
		d=>data_out,
		CLk=>CLK,
		we=>wef_s,
		spo=>NumberOUT
	);

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.arr_vector32.all;

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Instr : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is
	--PC Register part
	component basic_register
	port(
		CLK : IN  std_logic;
		WE : IN  std_logic;
		Datain : IN  std_logic_vector(31 downto 0);
		RST : IN  std_logic;
		Dataout : OUT  std_logic_vector(31 downto 0)
	);
	end component;
	
	--signals to handle input and output of the PC
	signal PC_input: std_logic_vector(31 downto 0);
	signal PC_output: std_logic_vector(31 downto 0);
	
	-- The mux part
	component mux2_1
	port(
		input : IN  arr_v32(0 to 1);
		sel : IN  std_logic;
		output : OUT  std_logic_vector(31 downto 0)
	);
	end component;
	
	-- the PC  increment part
	component se_m4_adder
	PORT(
      in_mul : IN  std_logic_vector(31 downto 0);
      in_add : IN  std_logic_vector(31 downto 0);
      result : OUT  std_logic_vector(31 downto 0)
	);
	END COMPONENT;
	
	-- in_mul is passed as is, in_add is PC out
	signal incr_result: STD_LOGIC_VECTOR(31 downto 0);
		
		
	-- tmp signals for synthesizability
	signal in_add: STD_LOGIC_VECTOR (31 downto 0);
	signal muxin: arr_v32(0 to 1);
	
	--rom decleration
	COMPONENT if_rom
	PORT(
        a : IN  std_logic_vector(9 downto 0);
		spo :OUT  std_logic_vector(31 downto 0)	
	);
	END COMPONENT;
	
begin
	PC: basic_register port map(
		CLK => Clk,				
      WE => PC_LdEn,			
      Datain => PC_input,	
      RST => Reset,				
      Dataout => PC_output	
	);

	Increment: se_m4_adder port map(
		in_mul => PC_Immed,			
      in_add => in_add,				
      result => incr_result		
	);
	
	multiplexer: mux2_1 port map(
		input => muxin,				
      sel => PC_sel,					
      output => PC_input			
	);
	
	mem_rom: if_rom port map(
		a => PC_output(11 downto 2),
      spo => Instr		
	);
	
	-- Circuit output is set to the output of the PC register
	in_add <= (PC_output + 4);
	muxin <= ((PC_output + 4), incr_result);

end Behavioral;


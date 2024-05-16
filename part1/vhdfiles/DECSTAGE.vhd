library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.arr_vector32.all;
use work.arr_vector5.all;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
           RST : in  STD_LOGIC);
end DECSTAGE;

architecture Behavioral of DECSTAGE is

	-- RF part
	component register_file
	port(
		Ard1 : IN  std_logic_vector(4 downto 0);
      Ard2 : IN  std_logic_vector(4 downto 0);
      Awr : IN  std_logic_vector(4 downto 0);
      WrEn : IN  std_logic;
      Clock : IN  std_logic;
      RST : IN  std_logic;
      Din : IN  std_logic_vector(31 downto 0);
      Dout1 : OUT  std_logic_vector(31 downto 0);
      Dout2 : OUT  std_logic_vector(31 downto 0)
	);
	end component;
	-- signals to handle RF Inputs Ard2 and Din
	signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
	signal Din : std_logic_vector(31 downto 0) := (others => '0');
	
	-- This mux handles the inputs ALU and MEM
	COMPONENT mux2_1
	PORT(
		input : IN  arr_v32(0 to 1);
		sel : IN  std_logic;
		output : OUT  std_logic_vector(31 downto 0)
		);
	END COMPONENT;	
	 
	-- This is the 5 bit mu
	COMPONENT mux2_1_5
	PORT(
			input : IN  arr_v5(0 to 1);
			sel : IN  std_logic;
			output : OUT  std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
	-- Signals to handle each of the two muxs's inputs
	-- First to handle the rd of the RF where we choose between parts of the Instr
	signal ra_mux_input : arr_v5(0 to 1) := (others => (others => '0'));
	-- Second handles the input singlas alu_out and mem_out 
	signal wd_mux_input : arr_v32(0 to 1) := (others => (others => '0'));
	
	-- The module that modifies the imm accoridngly
	COMPONENT im_mod
	PORT(
			opcode : IN  std_logic_vector(1 downto 0);
			imm_in : IN  std_logic_vector(15 downto 0);
			imm_out : OUT  std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
begin
	imm_modification: im_mod port map(
		opcode => ImmExt,
		imm_in => Instr(15 downto 0),
		imm_out => Immed
	);
	
	mux_of_5_bit: mux2_1_5 port map(
		input => ra_mux_input,
		sel => RF_B_sel,
		output => Ard2
	);
	
	alu_mem_mux: mux2_1 port map(
		input => wd_mux_input,
		sel => RF_WrData_sel,
		output => Din
	);
	
	rf: register_file port map(
		Ard1 => Instr(25 downto 21),
		Ard2 => Ard2,
		Awr => Instr(20 downto 16),
		WrEn => RF_WrEn,
		Clock => Clk,
		RST => RST,
		Din => Din,
		Dout1 => RF_A,
		Dout2 => RF_B
	);
	--Inserting Instr parts into the RF's adr2 
	ra_mux_input <= (Instr(15 downto 11), Instr(20 downto 16));
	-- Inserting alu_out and mem_out in the 2nd mux
	wd_mux_input <= (ALU_out, MEM_out);
end Behavioral;


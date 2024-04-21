library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.matrices.all;
use work.small_matrix.all;

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
		   RST : in STD_LOGIC);
end DECSTAGE;

architecture Behavioral of DECSTAGE is

    COMPONENT register_file
    PORT(
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
    END COMPONENT;
	-- RF Inputs
	signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
	signal Din : std_logic_vector(31 downto 0) := (others => '0');


	-- declare MUX components
	-- This is the mux that handles alu_out and mem_out
	COMPONENT mux2_1
	PORT(
			input : IN  MATRIX(0 to 1);
			sel : IN  std_logic;
			output : OUT  std_logic_vector(31 downto 0)
		);
	END COMPONENT;	
	-- Thisis this mux that handles part of the istr
	COMPONENT mux2_1_5bit
	PORT(
			input : IN  SMALL_MATRIX(0 to 1);
			sel : IN  std_logic;
			output : OUT  std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	-- MUX Inputs
	signal ra2_mux_input : SMALL_MATRIX(0 to 1) := (others => (others => '0'));
	signal wd_mux_input : MATRIX(0 to 1) := (others => (others => '0'));

	
	-- declare immediate handler component (zero fill, shift, singextend)
	COMPONENT imm_handler
	PORT(
			opcode : IN  std_logic_vector(1 downto 0);
			imm_in : IN  std_logic_vector(15 downto 0);
			imm_out : OUT  std_logic_vector(31 downto 0)
		);
	END COMPONENT;
		
begin
	cloud: imm_handler PORT MAP (
			opcode => ImmExt,
			imm_in => Instr(15 downto 0),
			imm_out => Immed
		);

	read_addr2_mux: mux2_1_5bit PORT MAP (
			input => ra2_mux_input,
			sel => RF_B_sel,
			output => Ard2
		);	
	
	write_data_mux: mux2_1 PORT MAP (
			input => wd_mux_input,
			sel => RF_WrData_sel,
			output => Din
		);
		
	RF: register_file PORT MAP (
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

	ra2_mux_input <= (Instr(15 downto 11), Instr(20 downto 16));
	wd_mux_input <= (ALU_out, MEM_out);
end Behavioral;


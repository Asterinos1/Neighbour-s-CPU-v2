library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0));
end EXSTAGE;

architecture Behavioral of EXSTAGE is

	COMPONENT ALU
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		Op : IN std_logic_vector(3 downto 0);          
		Out_1 : OUT std_logic_vector(31 downto 0);
		Zero : OUT std_logic;
		Cout : OUT std_logic;
		Ovf : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT s_mux
	PORT(
		input_1 : IN std_logic_vector(31 downto 0);
		input_2 : IN std_logic_vector(31 downto 0);
		sel_2 : IN std_logic;          
		output_2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	signal mux_alu: STD_LOGIC_VECTOR(31 downto 0);
	
begin

	ALU: ALU PORT MAP(
		A => RF_A,
		B => mux_alu,
		Op => ALU_func,
		Out_1 => ALU_out,
		Zero => open,
		Cout => open,
		Ovf => open
	);
	
	MUX: s_mux PORT MAP(
		input_1 => RF_B,
		input_2 => Immed,
		sel_2 => ALU_Bin_sel,
		output_2 => mux_alu
	);
	
end Behavioral;

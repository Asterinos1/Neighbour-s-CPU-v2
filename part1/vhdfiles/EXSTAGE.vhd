library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.arr_vector32.all;

entity EXSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_Sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC);
end EXSTAGE;

architecture Behavioral of EXSTAGE is
	
	-- the alu
	component ALU
	PORT(
		A : IN  std_logic_vector(31 downto 0);
		B : IN  std_logic_vector(31 downto 0);
		Op : IN  std_logic_vector(3 downto 0);
		Out_1 : OUT  std_logic_vector(31 downto 0);
		Cout : OUT  std_logic;
		Ovf : OUT  std_logic;
		Zero : OUT  std_logic
	 );
	END COMPONENT;

	signal B : std_logic_vector(31 downto 0) := (others => '0');

	COMPONENT mux2_1
	PORT(
		input : IN  arr_v32(0 to 1);
		sel : IN  std_logic;
		output : OUT  std_logic_vector(31 downto 0)
	 );
	END COMPONENT;
	
	-- signal to handle rf's b output and immed  signals to go into the mux
	signal mux_input: arr_v32(0 to 1):=(others=>(others=>'0'));
	
begin
	alu_unit: ALU PORT MAP (
		A => RF_A,
		B => B,
		Op => ALU_func,
		Out_1 => ALU_out,
		Cout => open,
		Ovf => open,
		Zero => ALU_zero
	);
	
	mux: mux2_1 PORT MAP (
		input => mux_input,
		sel => ALU_Bin_Sel,
		output => B
	);
	--inserting RF's b output and Immed in the mux
	mux_input <= (RF_B, Immed);

end Behavioral;


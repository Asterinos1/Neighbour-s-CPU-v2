library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           Instr : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

	COMPONENT if_rom
	PORT (
		a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT reg
	PORT(
		CLK : IN std_logic;
		WE : IN std_logic;
		Datain : IN std_logic_vector(31 downto 0);
		RST : IN std_logic;          
		Dataout : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;	
	-- Connection between PC register and ROM
	signal pc_mem: STD_LOGIC_VECTOR(31 downto 0);


	COMPONENT s_mux
	PORT(
		input_1 : IN std_logic_vector(31 downto 0);
		input_2 : IN std_logic_vector(31 downto 0);
		sel_2 : IN std_logic;          
		output_2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	signal mux_pc: STD_LOGIC_VECTOR(31 downto 0);	--Signal connecting mux output with PC reg input
	signal muxin : STD_LOGIC_VECTOR(31 downto 0);	

	component Immed_incr is
    Port ( Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           incr : in  STD_LOGIC_VECTOR (31 downto 0);
           res : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal imm_inc_res : STD_LOGIC_VECTOR (31 downto 0);
	signal pc_4 : STD_LOGIC_VECTOR(31 downto 0);
	signal pc_4_mux: STD_LOGIC_VECTOR(31 downto 0);

begin

	rom: if_rom
	PORT MAP (
		a => pc_mem(11 downto 2),
		spo => Instr
	);
	
	pc: reg PORT MAP(
		CLK => CLK,
		WE => PC_LdEn,
		Datain => mux_pc,
		RST => RST,
		Dataout => pc_mem
	);
	
	mux: s_mux
	PORT MAP (
		input_1 => imm_inc_res,
		input_2 => pc_4_mux,
		sel_2 => PC_Sel,
		output_2 => mux_pc
	);
	
	add: Immed_incr
	PORT MAP (
		Immed => PC_Immed,
		incr => pc_4,
		res => imm_inc_res
	);
	
	pc_4 <= (pc_mem + 4);
	pc_4_mux <= (pc_mem + 4);
	
end Behavioral;

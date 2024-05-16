library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This is the final top entity connecting datapth and control modules

entity CPU_TOP_ENTITY is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
end CPU_TOP_ENTITY;

architecture Behavioral of CPU_TOP_ENTITY is
	-- Declaring Datapath
	COMPONENT DATAPATH
		PORT(
			MM_RdData : IN  std_logic_vector(31 downto 0);
			ByteOp : IN  std_logic;
			MEM_WrEn : IN  std_logic;
			ALU_func : IN  std_logic_vector(3 downto 0);
			ALU_Bin_sel : IN  std_logic;
			RF_B_sel : IN  std_logic;
			RF_WrEn : IN  std_logic;
			RF_WrData_sel : IN  std_logic;
			ImmExt : IN  std_logic_vector(1 downto 0);
			PC_sel : IN  std_logic;
			PC_LdEn : IN  std_logic;
			MM_WrEn : OUT  std_logic;
			MM_Addr : OUT  std_logic_vector(9 downto 0);
			MM_WrData : OUT  std_logic_vector(31 downto 0);
			ALU_zero : OUT  std_logic;
			Instr : OUT  std_logic_vector(31 downto 0);
			RF_A: out STD_LOGIC_VECTOR(31 downto 0);
			RF_B: out STD_LOGIC_VECTOR(31 downto 0);
			RST : IN  std_logic;
			CLK : IN  std_logic
		);
	END COMPONENT;
	
   --Datapath signals
	signal Instr : std_logic_vector(31 downto 0);

	COMPONENT CONTROL
		PORT(
			Instruction : IN  std_logic_vector(31 downto 0);
			RF_A : IN  std_logic_vector(31 downto 0);
			RF_B : IN  std_logic_vector(31 downto 0);
			ByteOp : OUT  std_logic;
			MEM_WrEn : OUT  std_logic;
			ALU_func : OUT  std_logic_vector(3 downto 0);
         ALU_Bin_sel : OUT  std_logic;
         RF_B_sel : OUT  std_logic;
         RF_WrEn : OUT  std_logic;
         RF_WrData_sel : OUT  std_logic;
         ImmExt : OUT  std_logic_vector(1 downto 0);
         PC_sel : OUT  std_logic;
         PC_LdEn : OUT  std_logic
		);
	END COMPONENT;
	-- Control signals
	signal Instruction : std_logic_vector(31 downto 0);
	signal RF_A : std_logic_vector(31 downto 0);
	signal RF_B : std_logic_vector(31 downto 0);
	signal ByteOp : std_logic;
	signal MEM_WrEn : std_logic;
	signal ALU_func : std_logic_vector(3 downto 0);
	signal ALU_Bin_sel : std_logic;
	signal RF_B_sel : std_logic;
	signal RF_WrEn : std_logic;
	signal RF_WrData_sel : std_logic;
	signal ImmExt : std_logic_vector(1 downto 0);
	signal PC_sel : std_logic;
	signal PC_LdEn : std_logic;
	 
	-- RAM declaration
	COMPONENT RAM
	PORT(
		clk : IN  std_logic;
		we :  IN  std_logic;
		a : IN  std_logic_vector(9 downto 0);
		d : IN  std_logic_vector(31 downto 0);
		spo : OUT  std_logic_vector(31 downto 0)
	 );
	END COMPONENT;
	
	-- Signals for RAM
	signal WEA : std_logic;
	signal ADDRA : std_logic_vector(9 downto 0);
	signal DINA : std_logic_vector(31 downto 0);
	signal DOUTA : std_logic_vector(31 downto 0);
	signal temp: std_logic;
	
begin
	-- Instantiate the control module
	contrl: CONTROL PORT MAP (
		Instruction => Instruction,
		RF_A => RF_A,
		RF_B => RF_B,
		ByteOp => ByteOp,
		MEM_WrEn => MEM_WrEn,
		ALU_func => ALU_func,
		ALU_Bin_sel => ALU_Bin_sel,
		RF_B_sel => RF_B_sel,
		RF_WrEn => RF_WrEn,
		RF_WrData_sel => RF_WrData_sel,
		ImmExt => ImmExt,
		PC_sel => PC_sel,
		PC_LdEn => PC_LdEn
	);
	
	-- Instantiate the datapath module
	dtpath: DATAPATH PORT MAP (
		MM_RdData => DOUTA,
		ByteOp => ByteOp,
		MEM_WrEn => MEM_WrEn,
		ALU_func => ALU_func,
		ALU_Bin_sel => ALU_Bin_sel,
		RF_B_sel => RF_B_sel,
		RF_WrEn => RF_WrEn,
		RF_WrData_sel => RF_WrData_sel,
		ImmExt => ImmExt,
		PC_sel => PC_sel,
		PC_LdEn => PC_LdEn,
		MM_WrEn => WEA,
		MM_Addr => ADDRA,
		MM_WrData => DINA,
		ALU_zero => open,
		Instr => Instruction,
		RF_A => RF_A,
		RF_B => RF_B,
		RST => RST,
		CLK => CLK
	);
	
	-- RAM instantiation
	memory_module: RAM PORT MAP (
		clk => CLK,
		we => temp,
		a => ADDRA,
		d => DINA,
		spo => DOUTA
	);
	
	temp <=  '1' when WEA = '1' else '0';
end Behavioral;

	
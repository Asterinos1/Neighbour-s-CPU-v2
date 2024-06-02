library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROC_SC is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
end PROC_SC;

architecture Behavioral of PROC_SC is
	-- Declare the control component
	COMPONENT CONTROL
		PORT(
			Instruction : IN  std_logic_vector(31 downto 0);
			CLK : IN  std_logic;
			RST : IN  std_logic;
			E : IN  std_logic;
			ByteOp : OUT  std_logic;
			MEM_WrEn : OUT  std_logic;
			ALU_func : OUT  std_logic_vector(3 downto 0);
			ALU_Bin_sel : OUT  std_logic;
			RF_B_sel : OUT  std_logic;
			RF_WrEn : OUT  std_logic;
			RF_WrData_sel : OUT  std_logic;
			ImmExt : OUT  std_logic_vector(1 downto 0);
			PC_sel : OUT  std_logic;
			PC_LdEn : OUT  std_logic;
			IR_WrEn : OUT  std_logic
		);
	END COMPONENT;
	
	-- Control Signals
	signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
	signal E : std_logic := '0';
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
	signal IR_WrEn : std_logic;
	 
	 -- Declare the datapath component
	COMPONENT DATAPATH
		PORT(
			MM_RdData : IN  std_logic_vector(31 downto 0);
			ByteOp : IN  std_logic;
			MEM_WrEn : IN  std_logic;	
			ALU_func : IN  std_logic_vector(3 downto 0);
			ALU_Bin_sel : IN  std_logic;		
			IR_WrEn: IN STD_LOGIC;
			RF_B_sel : IN  std_logic;
			RF_WrEn : IN  std_logic;
			RF_WrData_sel : IN  std_logic;
			ImmExt : IN  std_logic_vector(1 downto 0);
			PC_sel : IN  std_logic;
			PC_LdEn : IN  std_logic;	
			E: OUT STD_LOGIC;
			MM_WrEn : OUT  std_logic;
			MM_Addr : OUT  std_logic_vector(9 downto 0);
			MM_WrData : OUT  std_logic_vector(31 downto 0);
			ALU_zero : OUT  std_logic;
			IR_o: OUT std_logic_vector(31 downto 0);
			RST : IN  std_logic;
			CLK : IN  std_logic
		);
	END COMPONENT;
  
	-- Datapath signals
	signal Instr : std_logic_vector(31 downto 0);
	signal IR_inter: STD_LOGIC_VECTOR(31 downto 0);

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
	
	-- Memory signals
	signal WEA : std_logic;
	signal ADDRA : std_logic_vector(9 downto 0);
	signal DINA : std_logic_vector(31 downto 0);
	signal DOUTA : std_logic_vector(31 downto 0);
	signal temp: std_logic;

begin

	-- Instantiate the control module
	ctrl: CONTROL PORT MAP (
			 Instruction => IR_inter,
          CLK => CLK,
          RST => RST,
          E => E,
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
          IR_WrEn => IR_WrEn
	);
	
	-- Instantiate the datapath module
	dpath: DATAPATH PORT MAP (
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
		E => E,
		RST => RST,
		CLK => CLK,
		IR_WrEn => IR_WrEn,
		IR_o => IR_inter
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

	
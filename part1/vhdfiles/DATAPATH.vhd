library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH is
    Port ( 
			  RST : in  STD_LOGIC;
            CLK : in  STD_LOGIC;
			  -- IFSTAGE
            PC_sel : in  STD_LOGIC;
            PC_LdEn : in  STD_LOGIC;
            Instr : out  STD_LOGIC_VECTOR (31 downto 0);
			  -- DECSTAGE
			RF_B_sel : in  STD_LOGIC;			  	  
            RF_WrEn : in  STD_LOGIC;
            RF_WrData_sel : in  STD_LOGIC;
            ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			RF_A: out STD_LOGIC_VECTOR (31 downto 0);
			RF_B: out STD_LOGIC_VECTOR (31 downto 0);
			-- EXSTAGE
			ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
            ALU_Bin_sel : in  STD_LOGIC;
			ALU_zero : out  STD_LOGIC;
			  -- MEMSTAGE
			MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
            ByteOp : in  STD_LOGIC;
            MEM_WrEn : in  STD_LOGIC;
            MM_WrEn : out  STD_LOGIC;
            MM_Addr : out  STD_LOGIC_VECTOR (9 downto 0);
            MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0)
			 );
end DATAPATH;

architecture Behavioral of DATAPATH is
	-- IFSTAGE 
  COMPONENT IFSTAGE
    PORT(
        PC_Immed : IN  std_logic_vector(31 downto 0);
        PC_sel : IN  std_logic;
        PC_LdEn : IN  std_logic;
        Reset : IN  std_logic;
        Clk : IN  std_logic;
        Instr : OUT  std_logic_vector(31 downto 0)
      );
  END COMPONENT;
  -- Intermidiate signals
  signal PC_Immed : std_logic_vector(31 downto 0);
  signal temp_Instr : std_logic_vector(31 downto 0);

	-- DECSTAGE 
	COMPONENT DECSTAGE
	  PORT(
        Instr : IN  std_logic_vector(31 downto 0);
        RF_WrEn : IN  std_logic;
        ALU_out : IN  std_logic_vector(31 downto 0);
        MEM_out : IN  std_logic_vector(31 downto 0);
        RF_WrData_sel : IN  std_logic;
        RF_B_sel : IN  std_logic;
        ImmExt : IN  std_logic_vector(1 downto 0);
        Clk : IN  std_logic;
		  RST: IN STD_LOGIC;
        Immed : OUT  std_logic_vector(31 downto 0);
        RF_A : OUT  std_logic_vector(31 downto 0);
        RF_B : OUT  std_logic_vector(31 downto 0)
      );
  END COMPONENT;

  -- Intermidiate signals
  signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
  signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
  signal Immed : std_logic_vector(31 downto 0);
  signal temp_RF_A : std_logic_vector(31 downto 0);
  signal temp_RF_B : std_logic_vector(31 downto 0);

	COMPONENT EXSTAGE
    PORT(
        RF_A : IN  std_logic_vector(31 downto 0);
        RF_B : IN  std_logic_vector(31 downto 0);
        Immed : IN  std_logic_vector(31 downto 0);
        ALU_Bin_Sel : IN  std_logic;
        ALU_func : IN  std_logic_vector(3 downto 0);
        ALU_out : OUT  std_logic_vector(31 downto 0);
        ALU_zero : OUT  std_logic
      );
  END COMPONENT;

  COMPONENT MEMSTAGE
    PORT(
        ByteOp : IN  std_logic;
        Mem_WrEn : IN  STD_LOGIC;
        ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
        MEM_DataIn : IN  std_logic_vector(31 downto 0);
        MEM_DataOut : OUT  std_logic_vector(31 downto 0);
        MM_WrEn : OUT  STD_LOGIC;
        MM_Addr : OUT  std_logic_vector(9 downto 0);
        MM_WrData : OUT  std_logic_vector(31 downto 0);
        MM_RdData : IN  std_logic_vector(31 downto 0)
      );
  END COMPONENT;
  --intermidiate signals
  signal i_MM_Addr : std_logic_vector(9 downto 0);
  signal i_MM_WrData : std_logic_vector(31 downto 0);

begin
	-- IFSTAGE Instantiation
	FETCH: IFSTAGE PORT MAP (
               PC_Immed => Immed,
               PC_sel => PC_sel,
               PC_LdEn => PC_LdEn,
               Reset => RST,
               Clk => CLK,
               Instr => temp_Instr
            );

	DEC: DECSTAGE PORT MAP (
          Instr => temp_Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          Clk => CLK,
			 RST => RST,
          Immed => Immed,
          RF_A => temp_RF_A,
          RF_B => temp_RF_B
        );

	EX: EXSTAGE PORT MAP (
          RF_A => temp_RF_A,
          RF_B => temp_RF_B,
          Immed => Immed,
          ALU_Bin_Sel => ALU_Bin_Sel,
          ALU_func => ALU_func,
          ALU_out => ALU_out,
          ALU_zero => ALU_zero
        );

	MEM: MEMSTAGE PORT MAP (
		ByteOp => ByteOp,
		Mem_WrEn => Mem_WrEn,
		ALU_MEM_Addr => ALU_out,
		MEM_DataIn => temp_RF_B,
		MEM_DataOut => MEM_out,
		MM_WrEn => MM_WrEn,
		MM_Addr => MM_Addr,
		MM_WrData => MM_WrData,
		MM_RdData => MM_RdData
	);
	
	-- passing temporary signals finally to RF_A, RF_B, Instr
	RF_A <= temp_RF_A;
	RF_B <= temp_RF_B;
	Instr <= temp_Instr;

end Behavioral;


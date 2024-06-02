library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH is
    Port ( 
			RST : in  STD_LOGIC;
			CLK : in  STD_LOGIC;
			-- IFSTAGE
			PC_sel : in  STD_LOGIC;
			PC_LdEn : in  STD_LOGIC;
			-- DECSTAGE
			RF_B_sel : in  STD_LOGIC;			 
			RF_WrEn : in  STD_LOGIC;
			RF_WrData_sel : in  STD_LOGIC;
			ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			--removed RF_A, RF_B
			-- ***NEW***
			E: out STD_LOGIC; -- for BEQ, BNE 		 
			-- EXSTAGE
			ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			ALU_Bin_sel : in  STD_LOGIC;
			ALU_zero : out  STD_LOGIC;
			-- ***NEW***
			ALU_out: out STD_LOGIC_VECTOR(31 downto 0);
			-- MEMSTAGE
			MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
			ByteOp : in  STD_LOGIC;
			MEM_WrEn : in  STD_LOGIC;
			MM_WrEn : out  STD_LOGIC;
			MM_Addr : out  STD_LOGIC_VECTOR (9 downto 0);
			MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);		  
			-- ***NEW***
			IR_WrEn: in STD_LOGIC;
			IR_o: out STD_LOGIC_VECTOR(31 downto 0));

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
	signal i_Instr : std_logic_vector(31 downto 0);

	-- DECSTAGE Declaration
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
			-- ***NEW***
			E: OUT std_logic;
			RF_B : OUT  std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	-- Intermidiate signals
	signal Immed : std_logic_vector(31 downto 0);
	signal reg_i_RF_A : std_logic_vector(31 downto 0);
	signal reg_i_RF_B : std_logic_vector(31 downto 0);
	signal reg_i_RF_E : std_logic;	

	-- EXSTAGE Declaration
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
	-- ***NEW***
	-- wire between alu out and the register
	signal reg_i_ALU_out : std_logic_vector(31 downto 0);

	-- MEMSTAGE Declaration
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

  signal i_MM_Addr : std_logic_vector(9 downto 0);
  signal i_MM_WrData : std_logic_vector(31 downto 0);
	-- ***NEW***
	-- wire between MEMSTAGE and MEM_out register
  signal reg_i_MEM_out: std_logic_vector(31 downto 0);
  
  -- ***NEW***
  -- REGISTER Declaration
	COMPONENT basic_register
	PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         Datain : IN  std_logic_vector(31 downto 0);
         RST : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
	END COMPONENT;
	
	-- ***NEW***
	signal IR_out: STD_LOGIC_VECTOR(31 downto 0)	:= (others => '0');	
	signal i_RF_A : std_logic_vector(31 downto 0)	:= (others => '0');
	signal i_RF_B : std_logic_vector(31 downto 0)	:= (others => '0');
	signal i_RF_E : std_logic_vector(31 downto 0)	:= (others => '0');
	signal i_ALU_out: std_logic_vector(31 downto 0)	:= (others => '0');
	signal i_MEM_out : std_logic_vector(31 downto 0):= (others => '0');
	signal i_E_Din: STD_LOGIC_VECTOR(31 downto 0)	:= (others => '0');

begin
	-- IFSTAGE Instantiation
	FETCH: IFSTAGE PORT MAP (
               PC_Immed => Immed,	
               PC_sel => PC_sel,
               PC_LdEn => PC_LdEn,
               Reset => RST,
               Clk => CLK,
               Instr => i_Instr
            );
			
	-- DECSTAGE Instantiation
	DEC: DECSTAGE PORT MAP (
			Instr => IR_out,
			RF_WrEn => RF_WrEn,
			ALU_out => i_ALU_out,
			MEM_out => i_MEM_out,
			RF_WrData_sel => RF_WrData_sel,
			RF_B_sel => RF_B_sel,
			ImmExt => ImmExt,
			Clk => CLK,
			RST => RST,
			Immed => Immed,
			RF_A => reg_i_RF_A,
			RF_B => reg_i_RF_B,
			-- ***NEW***
			E => reg_i_RF_E
        );

	-- EXSTAGE Instantiation
	EX: EXSTAGE PORT MAP (
          RF_A => i_RF_A,
          RF_B => i_RF_B,
          Immed => Immed,
          ALU_Bin_Sel => ALU_Bin_Sel,
          ALU_func => ALU_func,
		  -- ***NEW***
          ALU_out => reg_i_ALU_out,
          ALU_zero => ALU_zero
        );

	-- MEMSTAGE Instantiation
	MEM: MEMSTAGE PORT MAP (
		ByteOp => ByteOp,
		Mem_WrEn => Mem_WrEn,
		ALU_MEM_Addr => i_ALU_out,
		MEM_DataIn => i_RF_B,
		MEM_DataOut => reg_i_MEM_out,
		MM_WrEn => MM_WrEn,
		MM_Addr => MM_Addr,
		MM_WrData => MM_WrData,
		MM_RdData => MM_RdData
	);
	
	-- ***NEW***
	-- IR  register connects IFSTAGE with DECODE
	IR: basic_register PORT MAP(
		CLK => CLK,						
		WE => IR_WrEn,					
		Datain => i_Instr,				
		RST => RST,						
		Dataout => IR_out
	);
	
	-- ***NEW***
	-- A_reg and B_reg hold the outputs of RFA and RFB respectively
	A_reg: basic_register PORT MAP(
		CLK => CLK,						
		WE => '1',						
		Datain => reg_i_RF_A,		
		RST => RST,						
		Dataout => i_RF_A
	);
	
	-- ***NEW***
	B_reg: basic_register PORT MAP(
		CLK => CLK,						
		WE => '1',						
		Datain => reg_i_RF_B,		
		RST => RST,						
		Dataout => i_RF_B
	);
	
	-- ***NEW***
	i_E_Din <= (others => reg_i_RF_E);

	-- ***NEW***
	-- This register holds the output of the flag from DECODE stage
	E_reg: basic_register PORT MAP(
		CLK => CLK,								
		WE => '1',								
		Datain => i_E_Din,					
		RST => RST,								
		Dataout => i_RF_E
	);
	
	-- ***NEW***
	-- this register holds the ALU's result to be used in memory stage.
	ALU_out_reg: basic_register PORT MAP(
		CLK => CLK,						
		WE => '1',						
		Datain => reg_i_ALU_out,	
		RST => RST,						
		Dataout => i_ALU_out
	);
	
	-- ***NEW***
	-- This register holds the data read from memory to be written back to registers.
	MEM_out_reg: basic_register PORT MAP(
		CLK => CLK,						
		WE => '1',						
		Datain => reg_i_MEM_out,	
		RST => RST,						
		Dataout => i_MEM_out
	);
	
	-- ***NEW***
	E <= i_RF_E(0);
	IR_o <= IR_out;
	ALU_out <= i_ALU_out;
end Behavioral;


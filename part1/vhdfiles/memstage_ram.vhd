library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
	--This is the memstage's top module that handles the entire stage

entity MEMSTAGE_RAM is		-- ... the same as MEMSTAGE, only with a clock for the RAM module
	Port ( ByteOp : in  STD_LOGIC;
			MEM_WrEn : in std_logic_vector(0 downto 0);
			ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
			MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
			MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
			CLK: in STD_LOGIC);
end MEMSTAGE_RAM;

architecture Behavioral of MEMSTAGE_RAM is
 
    -- MEMSTAGE part
    COMPONENT MEMSTAGE
    PORT(
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic_vector(0 downto 0);
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic_vector(0 downto 0);
         MM_Addr : OUT  std_logic_vector(9 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
   
 	-- Singlas to handle the outputs of the memstage that control the ram
   signal i_MM_WrEn : std_logic_vector(0 downto 0);
   signal i_MM_Addr : std_logic_vector(9 downto 0);
   signal i_MM_WrData : std_logic_vector(31 downto 0);
   signal i_MM_RdData : std_logic_vector(31 downto 0);
	signal temp : std_logic;
   
	-- RAM declaration
	COMPONENT ram
	PORT(
		clk : IN  std_logic;
		we :  IN  std_logic;
		a : IN  std_logic_vector(9 downto 0);
		d : IN  std_logic_vector(31 downto 0);
		spo : OUT  std_logic_vector(31 downto 0)
	 );
	END COMPONENT;
 
BEGIN
 
	-- MEMSTAGE instantiation
	mem_stage: MEMSTAGE PORT MAP (
		ByteOp => ByteOp,
		Mem_WrEn => Mem_WrEn,
		ALU_MEM_Addr => ALU_MEM_Addr,
		MEM_DataIn => MEM_DataIn,
		MEM_DataOut => MEM_DataOut,
		MM_WrEn => i_MM_WrEn,
		MM_Addr => i_MM_Addr,
		MM_WrData => i_MM_WrData,
		MM_RdData => i_MM_RdData
	);
	-- RAM instantiation
	mem_ram: RAM PORT MAP (
		clk => CLK,
		we => temp,
		a => i_MM_Addr,
		d => i_MM_WrData,
		spo => i_MM_RdData
	);
	
	temp <=  '1' when i_MM_WrEn = "1" else '0';

end Behavioral;


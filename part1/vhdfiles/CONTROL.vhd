library ieee;  
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROL is
    Port ( Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
			  RF_A: in STD_LOGIC_VECTOR (31 downto 0);
			  RF_B: in STD_LOGIC_VECTOR (31 downto 0);
           ByteOp : out  STD_LOGIC;
           MEM_WrEn : out  std_logic;
           ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_Bin_sel : out  STD_LOGIC;
           RF_B_sel : out  STD_LOGIC;
           RF_WrEn : out  STD_LOGIC;
           RF_WrData_sel : out  STD_LOGIC;
           ImmExt : out  STD_LOGIC_VECTOR (1 downto 0);
           PC_sel : out  STD_LOGIC;
           PC_LdEn : out  STD_LOGIC);
end CONTROL;

architecture Behavioral of CONTROL is
	-- declare  temp signals 
	signal temp_ByteOp         : STD_LOGIC := '0';
	signal temp_MEM_WrEn       : STD_LOGIC := '0';
	signal temp_ALU_func       : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	signal temp_ALU_Bin_sel    : STD_LOGIC := '0';
	signal temp_RF_B_sel       : STD_LOGIC := '0';
	signal temp_RF_WrEn        : STD_LOGIC := '0';
	signal temp_RF_WrData_sel  : STD_LOGIC := '0';
	signal temp_ImmExt         : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	signal temp_PC_sel         : STD_LOGIC := '0';
	
	-- Function used for the bne, beq to check if the 2 32bit vectors (registers's content) are equal
	impure function compareVectors (vectorA : in STD_LOGIC_VECTOR (31 downto 0); 
											 vectorB : in STD_LOGIC_VECTOR (31 downto 0)) return STD_LOGIC is
		variable vectoreAvalue : integer;
		variable vectoreBvalue : integer;
		variable result  : STD_LOGIC;
		-- we convert the 2 vectors to integers and then simply compare them
		-- if they're equal, we return 1 (true)
		-- else we return 0 (false)
		begin
			vectoreAvalue := conv_integer(vectorA);
			vectoreBvalue := conv_integer(vectorB);
			if vectoreAvalue = vectoreBvalue then
				result := '1';
			else
				result := '0';
			end if;
		return result;
	end function;

begin
   PC_LdEn <= '1'; -- always write to PC	
   process (Instruction, RF_A, RF_B)
	begin
        case Instruction(31 downto 26) is
			when "100000"   =>  -- ALU instrs
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= Instruction(3 downto 0);
                temp_ALU_Bin_sel     <= '0'; 
                temp_RF_B_sel        <= '0'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "00"; 
                temp_PC_sel          <= '0';     
            when "111000"   =>  -- li    
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0011"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1';  
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0'; 
            when "111001"   => -- lui           
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0011"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "01";
                temp_PC_sel          <= '0'; 
            when "110000"   => -- addi            
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0000"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0';   
            when "110010"   => -- andi       
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0010"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "00";
                temp_PC_sel          <= '0';    
            when "110011"   => -- ori            
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0011"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "00";
                temp_PC_sel          <= '0';             
            when "111111"   => -- b         
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0';
                temp_ALU_func        <= "0111"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '0'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '1';           
            when "010000"   => -- beq        
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0111"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '0'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= compareVectors(RF_A, RF_B); 
            when "010001"   => -- bne          
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0111"; 
                temp_ALU_Bin_sel     <= '1';
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '0'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel 	      <= not compareVectors(RF_A, RF_B); --just add a not
            when "000011"   => -- lb                 
                temp_ByteOp          <= '1'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0000"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '1'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0';
            when "000111"   => -- sb      
                temp_ByteOp          <= '1'; 
                temp_MEM_WrEn        <= '1'; 
                temp_ALU_func        <= "0000"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '0'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0';
            when "001111"   => -- lw            
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '0'; 
                temp_ALU_func        <= "0000"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '1'; 
                temp_RF_WrData_sel   <= '1'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0'; 
            when "011111"   => -- sw            
                temp_ByteOp          <= '0'; 
                temp_MEM_WrEn        <= '1'; 
                temp_ALU_func        <= "0000"; 
                temp_ALU_Bin_sel     <= '1'; 
                temp_RF_B_sel        <= '1'; 
                temp_RF_WrEn         <= '0'; 
                temp_RF_WrData_sel   <= '0'; 
                temp_ImmExt          <= "10";
                temp_PC_sel          <= '0'; 
            when others     => -- default all zeros.
                temp_ByteOp          <= '0';
                temp_MEM_WrEn        <= '0';
                temp_ALU_func        <= "0111";
                temp_ALU_Bin_sel     <= '0';
                temp_RF_B_sel        <= '0';
                temp_RF_WrEn         <= '0';
                temp_RF_WrData_sel   <= '0';
                temp_ImmExt          <= "00";
                temp_PC_sel          <= '0';        
        end case;
    end process;
	 -- Finally pass the values to their corresponding singlas for the datapath
    ByteOp       <= temp_ByteOp;
    MEM_WrEn     <= temp_MEM_WrEn;
    ALU_func     <= temp_ALU_func;
    ALU_Bin_sel  <= temp_ALU_Bin_sel;
    RF_B_sel     <= temp_RF_B_sel;
    RF_WrEn      <= temp_RF_WrEn;
    RF_WrData_sel<= temp_RF_WrData_sel;
    ImmExt       <= temp_ImmExt;
    PC_sel       <= temp_PC_sel;
  
end Behavioral;

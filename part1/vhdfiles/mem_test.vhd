LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mem_test2 IS
END mem_test2;
 
ARCHITECTURE behavior OF mem_test2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMSTAGE
    PORT(
			ByteOp : in  STD_LOGIC;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         Mem_DataIn : IN  std_logic_vector(31 downto 0);
         Mem_DataOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
	signal ByteOp : STD_LOGIC := '0';
   signal Mem_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal Mem_DataIn : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Mem_DataOut : std_logic_vector(31 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE PORT MAP (
			 ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          Mem_DataIn => Mem_DataIn,
          Mem_DataOut => Mem_DataOut
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
     -- Initialize inputs
    Mem_WrEn <= '0';
    ALU_MEM_Addr <= (others => '0');
    Mem_DataIn <= (others => '0');
    wait for 100 ns;  

    --Write to memory
    Mem_WrEn <= '1';  
    ALU_MEM_Addr <= "00000000010000000000000000000000"; 
    Mem_DataIn <= x"ABCD1234";  
    wait for 100 ns;  

    Mem_WrEn <= '0';  
    wait for 100 ns;  

    -- Read from memory 
    ALU_MEM_Addr <= "00000000010000000000000000000000"; 
    wait for 100 ns;  
    wait;
   end process;

END;

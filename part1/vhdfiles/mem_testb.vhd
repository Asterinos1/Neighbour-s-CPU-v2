LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY mem_ram_test IS
END mem_ram_test;
 
ARCHITECTURE behavior OF mem_ram_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT MEMSTAGE_RAM
    PORT(
         ByteOp : IN  std_logic;
         MEM_WrEn : IN  std_logic_vector(0 downto 0);
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         CLK : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal ByteOp : std_logic := '0';
   signal MEM_WrEn :std_logic_vector(0 downto 0) := (others => '0');
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE_RAM PORT MAP (
          ByteOp => ByteOp,
          MEM_WrEn => MEM_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          MEM_DataOut => MEM_DataOut,
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- lb
		-- sb
		-- lw
		-- sw
		
		-- first try to save a byte
		ByteOp <= '1';
		MEM_WrEn <= "1";
		ALU_MEM_Addr <= x"00000010";		-- lets save it in address 4. We pass 16 as the address, because it will be divided by 4
		MEM_DataIn	<= x"000000FF";		-- only the LS byte will be saved
      wait for 100 ns;	
		
		-- then read the byte
		MEM_WrEn <= "0";
		wait for 100 ns;	-- expected output is MEM_DataOut = 000000FF after 100 ns
		
		-- repeat the byte saving
		ByteOp <= '1';
		MEM_WrEn <= "1";
		ALU_MEM_Addr <= x"00000018";	-- lets save it in address 6. We pass 24 as the address, because it will be divided by 4
		MEM_DataIn	<= x"C0FFEEFF";	-- try the same with non zero bits in MEM_DataIn(31 downto 8), nothing should change
      wait for 100 ns;
		
		-- then read the byte
		MEM_WrEn <= "0";
		wait for 100 ns;	-- expected output is MEM_DataOut = 0000000FF till 400 ns
		
		
		-- then try to save a word
		ByteOp <= '0';
		MEM_WrEn <="1";
		ALU_MEM_Addr <= x"00000030";
		MEM_DataIn <= x"7C0FFEE7";
		wait for 100 ns;
		
		-- then read the word
		MEM_WrEn <= "0";
		wait for 100 ns;	-- expected output is MEM_DataOut = 7C0FFEE7 after 500 ns
		
		-- then read a byte of the saved word
		ByteOp <= '1';
		wait for 100 ns;	-- expected output is MEM_DataOut = 000000E7 after 600 ns
		
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

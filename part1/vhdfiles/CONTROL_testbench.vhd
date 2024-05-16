LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY CONTROL_testbench IS
END CONTROL_testbench;
 
ARCHITECTURE behavior OF CONTROL_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         Instruction : IN  std_logic_vector(31 downto 0);
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         ByteOp : OUT  std_logic;
         MEM_WrEn : OUT  std_logic_vector(0 downto 0);
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
    

   --Inputs
   signal Instruction : std_logic_vector(31 downto 0) := x"15000000";
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
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

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
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

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		-- test addi r5, r0, 8
		Instruction <= x"C0050008";
		wait for 100 ns;
		
		-- test ori r3, r0, 0xABCD
		Instruction <= x"CC03ABCD";
		wait for 100 ns;
		
		-- test sw r3, 4(r0)
		Instruction <= x"7C030004";
		wait for 100 ns;
		
		-- test lw r10, -4(r5)
		Instruction <= x"3CAAFFFC";
		wait for 100 ns;
		
		-- test lb r16, 4(r0)
		Instruction <= x"0C100004";
		wait for 100 ns;
		
		-- test nand r4, r10, r16
		Instruction <= x"81448035";
		wait for 100 ns;
		
		-- test bne r5, r5, 8 
		Instruction <= x"04A50008";
		wait for 100 ns;

		-- test that bne works with non equal registers
		RF_A <= x"ABCDEF10";
		wait for 100 ns;		
		
		-- test b -2
		Instruction <= x"FC00FFFE";
		wait for 100 ns;
		
		-- test addi r1, r0, 1
		Instruction <= x"C0010001";
		wait for 100 ns;
		
      -- insert stimulus here 

      wait;
   end process;

END;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY DECSTAGE_testbench IS
END DECSTAGE_testbench;
 
ARCHITECTURE behavior OF DECSTAGE_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
			RST: IN std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
	signal RST : std_logic := '0';
 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: DECSTAGE PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          Clk => Clk,
			 RST => RST,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
        );

	-- Clock process definitions
	Clk_process :process
	begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
	end process;
 

	-- Stimulus process
	stim_proc: process
	begin
		-- Set Instr to an I-type instruction (addi, opcode 110000), with an immediate value of ABCD.
        -- Also set ImmExt to 10, so that the immediate is sign extended and not shifted.
		Instr          <= "11000000000000011010101111001101"; -- immed is ABCD
		RF_B_sel       <= '1';     -- 1, as this is an I type instruction and rd is at indexes [20,16] (irrelevant)
		ImmExt         <= "10";    -- we need simple sign extension    
        wait for 100 ns;     -- expected result is Immed = FFFF ABCD

		-- Repeat the same as above, with RF_B_sel unset to make sure nothing weird happens
		RF_B_sel       <= '0';  -- confirm that this is irrelevant as to the immediate's value
		wait for 100 ns;     -- expected result is Immed = FFFF ABCD
		
		-- Set Instr to an R-type instruction (and, opcode 100000, func 110010)
		-- We now want to see rd, rs and rt at  RF's write addr, read addr 1 and 2 accordingly
		Instr          <= "10000000011000010011100000110010"; -- rd = rs and rf, $1 = $3 and $7
		ImmExt         <= "00";   -- reset that too, even though we do not really care about the immediate    
		wait for 100 ns;     -- expected result RF_A = 00...011, RF_B = 00...00111

		-- Repeat the same with RF_B_sel set, so rt is overlooked and RF_B is set to rd
		RF_B_sel       <= '1';  -- 0, as the second read register is rt, at indexes [15, 11]
		wait for 100 ns;     -- expected result RF_A = 00...001, RF_B = 00...00111

		-- Try to write to RF.
		-- This will be done with some input data, lets say from the ALU
		-- We expect RF[7] to change to 7BAD after ... 2 clock cycles. Ston prwto den exei erthei akoma to we apo to intermediate we array sto reg$7, vlepe kymatomorfh
		RF_WrEn <= '1';   -- enable writing
		RF_B_sel <= '1';  -- I type instruction
		ImmExt <= "10";   -- we only want sign extension
		Instr <= "11000000111001110111101110101101"; -- set all rs=rd=7, so the result is read in both RF_A and RF_B
		RF_WrData_sel <= '0';   -- 0 for ALU, suppose result comes from there
		ALU_out <= x"00C0FFEE";
		wait for 100 ns; 

		wait;
	end process;

END;

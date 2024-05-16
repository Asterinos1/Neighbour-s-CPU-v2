LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY dec_test IS
END dec_test;
 
ARCHITECTURE behavior OF dec_test IS 
 
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
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0);
         RST : IN  std_logic
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
   constant Clk_period : time := 10 ns;
 
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
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B,
          RST => RST
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
		Instr          <= "11000000000000011010101111001101"; 
		RF_B_sel       <= '1';     
		ImmExt         <= "10";        
      wait for 100 ns;    

		RF_B_sel       <= '0';  
      wait for 100 ns;     
		
		Instr          <= "10000000011000010011100000110010"; 
		ImmExt         <= "00";   
      wait for 100 ns;     

		RF_B_sel       <= '1';  
      wait for 100 ns;    
 
      RF_WrEn <= '1';   
      RF_B_sel <= '1';  
      ImmExt <= "10";   
      Instr <= "11000000111001110111101110101101"; 
      RF_WrData_sel <= '0';   
      ALU_out <= x"00C0FFEE";
      
      wait for 100 ns; 

      wait;
   end process;

END;
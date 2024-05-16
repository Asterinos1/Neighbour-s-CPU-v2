LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY if_test IS
END if_test;
 
ARCHITECTURE behavior OF if_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal Instr : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE PORT MAP (
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          Clk => Clk,
          Instr => Instr
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
		Reset <= '1';
      wait for 100 ns;	
		Reset <= '0';
		PC_LdEn <= '1';
		wait for 100 ns;	
      
		PC_LdEn <= '0';
		Reset <= '1';
		wait for 100 ns;
		
		Reset <= '0';
		PC_Immed <= x"00000064";
		PC_sel <= '1';
		wait for 100 ns;	
		
		PC_LdEn <= '1';
		wait for 100 ns;
		
		PC_Immed <= x"00000000";
		wait for 100 ns;			
		
		PC_Immed <= x"00000025";
		wait for 100 ns;	

		Reset <= '1';
		wait for 100 ns;	
		
		PC_sel <= '0';
		Reset <= '0';
		wait for 400 ns;	
		
		PC_sel <= '1';
		PC_Immed <= x"00000014";
		wait for 100 ns; 
		
		PC_Immed <= x"00000018";
		wait for 100 ns; 
		
		PC_sel <= '0';
		wait for 200 ns;	
		
		PC_sel <= '1';
		PC_Immed <= x"00000016"; 
      wait;
   end process;

END;
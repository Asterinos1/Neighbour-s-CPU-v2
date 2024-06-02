LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY CPU_TOP_ENTITY_test IS
END CPU_TOP_ENTITY_test;
 
ARCHITECTURE behavior OF CPU_TOP_ENTITY_test IS 
 
    COMPONENT PROC_SC
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROC_SC PORT MAP (
          CLK => CLK,
          RST => RST
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
      -- hold reset state for 100 ns.
		RST <= '1';
      wait for 100 ns;	
		RST <= '0';
		
		
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
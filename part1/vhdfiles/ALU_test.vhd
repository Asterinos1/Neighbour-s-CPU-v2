LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         Out_1 : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        ); 
    END COMPONENT;
      
 
   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');
 
 	--Outputs
   signal Out_1 : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A, 
          B => B,
          Op => Op,
          Out_1 => Out_1,
          Zero => Zero, 
          Cout => Cout,
          Ovf => Ovf);
   -- Stimulus process
   stim_proc: process
   begin		
		A<="11111111111111111111111111111111";
		B<="11111111111111111111111111111111";
		Op<="0000";
		wait for 50 ns;
     	A<="00000000000000000000000000000000";
		B<="00000000000000000000000000000001";
		Op<="0000";
      wait for 50 ns;
	   A<="10000100000000000000000011111111";
		B<="10110011111111111111111111111111";
		Op<="0000";
      wait for 50 ns;
		A<="00000000000000000000000000000001";
		B<="00000000000000000000000000000001";
		Op<="0001";
      wait for 50 ns;
	   A<="01111111111111111111111111111111";
		B<="10100000000000001111111100000110";
		Op<="0001";
      wait for 50 ns;	
		A<="11111111000000000000000000000111";
		B<="11111111100000000000000000000001";
		Op<="0000";
      wait for 50 ns;
	   A<="00000000000000000000000011111111";
		B<="00000000000000000111100000000000";
		Op<="0000";
      wait for 50 ns;
		A<="11111111000000000000000000000111";
		B<="11111111100000000000000000000001";
		Op<="0001";
      wait for 50 ns;
	   A<="00000000000000000000000011111111";
		B<="00000000000000000111100000000000";
		Op<="0001";
      wait for 50 ns;
		A<="00000000000000000000000011111111";
		B<="00000000000000000111100000011000";
		Op<="0010";
      wait for 50 ns;
      A<="00110000000000000010000011111111";
		B<="00000000000000000111100000000111";
		Op<="0011";
      wait for 50 ns;
	   A<="00111111111111110010000011111111";
		B<="00000000000000000111100000000111";
		Op<="0100";
      wait for 50 ns;
     	A<="11110000000000000000000000000000";
		Op<="1001";
      wait for 50 ns;	
		A<="11111111111111111111111111111111";
		Op<="1001";
      wait for 50 ns;			
	   A<="00000000000000000000000000000000";
		Op<="1010";
      wait for 50 ns;	
		A<="00000000000000000000000000000001";
		Op<="1010";
      wait for 50 ns;	

      wait;
   end process;

END;

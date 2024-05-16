LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.arr_vector5.all;
 
ENTITY ex_test IS
END ex_test;
 
ARCHITECTURE behavior OF ex_test IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT EXSTAGE
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_Bin_Sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         ALU_zero : OUT  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_Bin_Sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal ALU_zero : std_logic;
	
	-- declare an array of all possible opcodes
	signal codes: arr_v5(0 to 9) := ("00000", "00001", "00010", "00011", "00100", "00101", "01001", "01010", "01100", "01101");
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXSTAGE PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALU_Bin_Sel => ALU_Bin_Sel,
          ALU_func => ALU_func,
          ALU_out => ALU_out,
          ALU_zero => ALU_zero
        );

   -- Stimulus process
   stim_proc: process
   begin		
		-- Loop through all codes(i) and for each code we swap alu_bin_sel		
		for i in 0 to 9 loop
			RF_A <= x"00700000";
			RF_B <= x"00C0FFEE";
			ALU_Bin_Sel <= '0';	-- sel RF_B
			ALU_func <= codes(i)(3 downto 0);
			wait for 100 ns;			
			
			RF_A <= x"DEAD0000";
			Immed <= x"0000BEEF";
			ALU_Bin_Sel <= '1';	-- sel RF_B
			ALU_func <= codes(i)(3 downto 0);
			wait for 100 ns;	
		end loop;
      wait;
   end process;
END;

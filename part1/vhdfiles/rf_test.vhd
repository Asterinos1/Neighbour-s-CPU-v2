LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY rf_test IS
END rf_test;
 
ARCHITECTURE behavior OF rf_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         WrEn : IN  std_logic;
         Clock : IN  std_logic;
         RST : IN  std_logic;
         Din : IN  std_logic_vector(31 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal Clock : std_logic := '0';
   signal RST : std_logic := '0';
   signal Din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          WrEn => WrEn,
          Clock => Clock,
          RST => RST,
          Din => Din,
          Dout1 => Dout1,
          Dout2 => Dout2
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

		-- set "cursor" (write address) to 1 (instead of default 0), as $0 is always 0 and cant be overwritten
		Awr <= "00001"; 
		
		-- firstly, test the reset signal
		-- expected result is that Dout1 and Dout2 are set to 0 
		RST <= '1';
		wait for 200 ns; 
		
		-- then test that while reset is on and write enable is off, Din has no effect
		Din <= X"ABCDEF12";
		wait for 200 ns;
		
		-- then test that while reset is on, even if write enable is on it is ignored
		WrEn <= '1';
		wait for 200 ns;

		-- then test that insertion works correctly (WrEn and Din are set, we just turn off RST)
		--
		-- Expected result is that in the next clock pulse WrEn on $1 turns on.
		RST <= '0';
		Ard1 <= "00001";
		wait for 200 ns;
		
		
		-- then just read
		WrEn <= '0';
		wait for 200 ns;
		
		-- then insert in $16
		--Ard1 <= "00001";
		Awr <= "10000";
		WrEn <= '1';
		Din <= X"FFFFFFFF";
		wait for 200 ns; -- output should not change
		
		-- then read from $16
		WrEn <= '0';
		Ard1 <= "10000";
		Ard2 <= "00001";
		wait for 200 ns; -- output should change
		
		-- then read from $1 again
		Ard1 <= "00001";
		wait for 200 ns;
		
		-- with both outputs
		Ard2 <= "00001";
		wait for 200 ns;
		
		-- then reset
		RST <= '1';
		WrEn <= '0';
		wait for 200 ns; -- Douts should become zero 
		
		
		-- then check $16 has reset successfully
		Awr <= "01010";
		Awr <= "01010";
		RST <= '0';
		Ard1 <= "10000";
		wait for 200 ns; -- Dout1 doesnt change, it was already 0
		
		Ard2 <= "10000";
		wait for 200 ns; -- Dout2 doesnt change, it was already 0

      wait;
   end process;

END;

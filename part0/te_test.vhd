--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:45:47 03/24/2024
-- Design Name:   
-- Module Name:   /home/polychronis/Projects/neighbour-s-cpu-v2/part0/te_test.vhd
-- Project Name:  Project0
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_entity_module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY te_test IS
END te_test;
 
ARCHITECTURE behavior OF te_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_entity_module
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         AddrWrite : IN  std_logic_vector(4 downto 0);
         AddrRead : IN  std_logic_vector(4 downto 0);
         WriteF : IN  std_logic;
         ReadF : IN  std_logic;
         NumberIN : IN  std_logic_vector(15 downto 0);
         NumberOUT : OUT  std_logic_vector(15 downto 0);
         Valid : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal AddrWrite : std_logic_vector(4 downto 0) := (others => '0');
   signal AddrRead : std_logic_vector(4 downto 0) := (others => '0');
   signal WriteF : std_logic := '0';
   signal ReadF : std_logic := '0';
   signal NumberIN : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal NumberOUT : std_logic_vector(15 downto 0);
   signal Valid : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_entity_module PORT MAP (
          CLK => CLK,
          RST => RST,
          AddrWrite => AddrWrite,
          AddrRead => AddrRead,
          WriteF => WriteF,
          ReadF => ReadF,
          NumberIN => NumberIN,
          NumberOUT => NumberOUT,
          Valid => Valid
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
      --wait for 100 ns;	
		ReadF <= '1';
		WriteF <= '0';
		AddrRead <= b"00011";
				
      wait for CLK_period;
		ReadF <= '0';
		WriteF <= '1';
		NumberIN <= "1011011010110011";
		AddrWrite <= "00011";
		wait for CLK_period;
		
		ReadF <= '1';
		WriteF <= '0';
		AddrRead <= b"00011";

      -- insert stimulus here 

      wait;
   end process;

END;

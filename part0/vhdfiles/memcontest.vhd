--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:34:02 03/28/2024
-- Design Name:   
-- Module Name:   /home/polychronis/Projects/part0/memcontest.vhd
-- Project Name:  part0
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memory_controller
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
 
ENTITY memcontest IS
END memcontest;
 
ARCHITECTURE behavior OF memcontest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory_controller
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         AddrW : IN  std_logic_vector(4 downto 0);
         AddrR : IN  std_logic_vector(4 downto 0);
         Wf : IN  std_logic;
         Rf : IN  std_logic;
         AddrOUT : OUT  std_logic_vector(4 downto 0);
         WEf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal AddrW : std_logic_vector(4 downto 0) := (others => '0');
   signal AddrR : std_logic_vector(4 downto 0) := (others => '0');
   signal Wf : std_logic := '0';
   signal Rf : std_logic := '0';

 	--Outputs
   signal AddrOUT : std_logic_vector(4 downto 0);
   signal WEf : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory_controller PORT MAP (
          CLK => CLK,
          RST => RST,
          AddrW => AddrW,
          AddrR => AddrR,
          Wf => Wf,
          Rf => Rf,
          AddrOUT => AddrOUT,
          WEf => WEf
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
		wait for CLK_period;
		
		AddrW <= "01010";
		AddrR <= "10101";
		Wf <= '1';
		Rf <= '0';
		Wait for CLK_period*10;
		
		AddrW <= "01010";
		AddrR <= "10101";
		Wf <= '0';
		Rf <= '1';
		Wait for CLK_period*10;
		
		
		

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

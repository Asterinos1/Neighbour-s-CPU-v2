--------------------------------------------------------------------------------
-- Project Name:  lab1_organwsh_datapath
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DATAPATH_and_RAM
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
 
ENTITY DATAPATH_and_RAM_testbench IS
END DATAPATH_and_RAM_testbench;
 
ARCHITECTURE behavior OF DATAPATH_and_RAM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH_and_RAM
    PORT(
         ByteOp : IN  std_logic;
         MEM_WrEn : IN  std_logic_vector(0 downto 0);
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_Bin_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         RF_WrEn : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         --PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ByteOp : std_logic := '0';
   signal MEM_WrEn : std_logic_vector(0 downto 0) := (others => '0');
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal RF_WrEn : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH_and_RAM PORT MAP (
          ByteOp => ByteOp,
          MEM_WrEn => MEM_WrEn,
          ALU_func => ALU_func,
          ALU_Bin_sel => ALU_Bin_sel,
          RF_B_sel => RF_B_sel,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          ImmExt => ImmExt,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RST => RST,
          CLK => CLK
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
		
		
		-- test addi instruction :
		-- addi r5, r0, 8 (C005 0008 in HEX)
          -- Immediate goes to DEC, gets sign extended
          -- Then it goes to ALU, gets added with RF[rs]
          -- Then it goes back to RF, gets written in RF[rd]
          ByteOp          <= '0';
          MEM_WrEn        <= "0";
          ALU_func        <= "0000"; -- add
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed)
          RF_B_sel        <= '0'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) we dont care though
          RF_WrEn         <= '1'; -- (allow writing to rd)
          RF_WrData_sel   <= '0'; -- (0-> ALU_out, 1-> MEM_out) (alu out is RF_A + Immed)
          ImmExt          <= "10"; -- (means zero fill, left logical shift)
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns;

		-- test ori instruction 
		-- ori r3, r0, 0xABCD
          -- Immediate goes to DEC, gets sign extended
          -- Then it goes to ALU, gets OR'ed with RF[rs]
          -- Then it goes back to RF, gets written in RF[rd]
          ByteOp          <= '0';
          MEM_WrEn        <= "0";
          ALU_func        <= "0011"; -- or
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed) 
          RF_B_sel        <= '0'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) we dont care though
          RF_WrEn         <= '1'; -- (allow writing to rd)
          RF_WrData_sel   <= '0'; -- (0-> ALU_out, 1-> MEM_out) (alu out is RF_A | Immed)
          ImmExt          <= "00"; -- (means zero fill, left logical shift)
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns;


      -- test sw instruction :
	   -- sw r3, 4(r0)
          -- The same as sb, but with ByteOp unset
          ByteOp          <= '0'; -- cut and zerofill the contents of the given register
          MEM_WrEn        <= "1"; -- write to memory
          ALU_func        <= "0000"; -- add
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed)
          RF_B_sel        <= '1'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) RF_B is rt, though we don't care
          RF_WrEn         <= '0'; -- (dont write to any register)
          RF_WrData_sel   <= '0'; -- (0-> ALU_out, 1-> MEM_out) (irrelevant, since it refers to where the data that will be saved in the RF come from and no data will be written to the RF)
          ImmExt          <= "10"; -- (means sign exted, no shift) SHOULDN'T SIGN EXTEND, LETS US VULNERABLE TO OVERFLOW ATTACKS
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns;
  -------------------------------------------
      -- test lw instruction 
	   -- lw r10, -4(r5) 
          -- The same as lb, but with ByteOp unset
          ByteOp          <= '0';
          MEM_WrEn        <= "0"; -- no need to write to memory
          ALU_func        <= "0000"; -- add
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed)
          RF_B_sel        <= '0'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) RF_B is rt, though we don't care
          RF_WrEn         <= '1'; -- (write to rd)
          RF_WrData_sel   <= '1'; -- (0-> ALU_out, 1-> MEM_out) (MEM_out is the byte we want to save in RF[rd])
          ImmExt          <= "10"; -- (means sign exted, no shift) SHOULDN'T SIGN EXTEND, LETS US VULNERABLE TO OVERFLOW ATTACKS
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns;
   
      -- test lb instruction:
      -- lb r16, 4(r0)
          -- Immediate goes to DEC, gets sign extended
          -- Then it goes to ALU, and it is added with RF[rs] (RF_A)
          -- The result then goes to MEM, at ALU_MEM_Addr
          -- The output of MEM is RAM[ALU_MEM_Addr](7 downto 0), because ByteOp is set
          -- The output of MEM then goes to RF, as MEM_out
          ByteOp          <= '1'; -- cut and zerofill the contents of the given memory address
          MEM_WrEn        <= "0"; -- no need to write to memory
          ALU_func        <= "0000"; -- add
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed)
          RF_B_sel        <= '0'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) RF_B is rt, though we don't care
          RF_WrEn         <= '1'; -- (write to rd)
          RF_WrData_sel   <= '1'; -- (0-> ALU_out, 1-> MEM_out) (MEM_out is the byte we want to save in RF[rd])
          ImmExt          <= "10"; -- (means sign exted, no shift) SHOULDN'T SIGN EXTEND, LETS US VULNERABLE TO OVERFLOW ATTACKS
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns;
			 
			 
			-- test any ALU instruction :
			-- and r4, r10, r16
          ByteOp          <= '0';
          MEM_WrEn        <= "0";
          ALU_func        <= "0010";	-- add for example
          ALU_Bin_sel     <= '0'; -- (ALU_B is RF_B)
          RF_B_sel        <= '0'; -- (0-> 15-11 (rt), 1-> 20-16 (rd))
          RF_WrEn         <= '1'; -- (allow writing to rd)
          RF_WrData_sel   <= '0'; -- (0-> ALU_out, 1-> MEM_out)
          ImmExt          <= "00"; -- (means zerofill, no shift, but we don't care anyway)
          PC_sel          <= '0'; -- (PC+4)
          PC_LdEn         <= '1';
          wait for 100 ns; -- 700
			 
			  -- test bne instruction :
          -- Immediate goes to DEC, gets sign extended
          -- Then it gets shifted by 2, goes to IF
          -- Meanwhile RF[rs] is compared with RF[rd]
          -- If they are not equal, the immediate is multiplied by 4 and added to the PC
          -- If they are, PC = PC+4
          ByteOp          <= '0';
          MEM_WrEn        <= "0";
          ALU_func        <= "0111"; -- noop
          ALU_Bin_sel     <= '1'; -- (ALU_B is Immed)
          RF_B_sel        <= '1'; -- (0-> 15-11 (rt), 1-> 20-16 (rd)) RF_B is rd
          RF_WrEn         <= '0'; -- (dont write to rd)
          RF_WrData_sel   <= '0'; -- (0-> ALU_out, 1-> MEM_out) (alu out is RF_A, but we don't care)
          ImmExt          <= "10"; -- (means sign exted, no shift) SHOULDN'T SIGN EXTEND, LETS US VULNERABLE TO OVERFLOW ATTACKS
          PC_sel          <= '0';-- if RF_A is not RF_B, 0 if it is'; -- ((PC+4) + (Immed*4))
          PC_LdEn         <= '1';
          wait for 800 ns;

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

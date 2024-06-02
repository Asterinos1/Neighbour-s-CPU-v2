library ieee;  
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROL is
    Port ( 
			Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
			CLK : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			-- ***NEW***
			E : IN STD_LOGIC;	
			ByteOp : out  STD_LOGIC;
			MEM_WrEn : out  std_logic;
			ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
			ALU_Bin_sel : out  STD_LOGIC;
			RF_B_sel : out  STD_LOGIC;
			RF_WrEn : out  STD_LOGIC;
			RF_WrData_sel : out  STD_LOGIC;
			ImmExt : out  STD_LOGIC_VECTOR (1 downto 0);
			PC_sel : out  STD_LOGIC;
			PC_LdEn : out  STD_LOGIC;
  			IR_WrEn : out STD_LOGIC);
end CONTROL;

architecture Behavioral of CONTROL is
	-- removed impure function compareVectors() from previous implementation 
	-- ***NEW***
	-- declare states of our FSM:
	-- Reset: self-explenatory
	-- Fetch: --
	-- I_DEC: decode state
	-- BRANCH_COMPL: handles branch instructions: BEQ, BNE, or just B
	-- R_EXEC: handles the ALU instructions (Execute stage)
	-- MEM_EXEC: handles the memory instructions (MEM stage)
	-- R_WB: This is the write back state for instructions that write to registers of the RF
	-- S_MEM: This state is next after MEM_EXEC and handles the store to memory 
	-- L_MEM: This state is also next after MEM_EXEC and handles to read from memory
	-- L_WB: this is an extra part after L_MEM which writes back after L_MEM to RF's registers.
	type state_type is (RESET, FETCH, I_DEC, BRANCH_COMPL, R_EXEC, MEM_EXEC, R_WB, S_MEM, L_MEM, L_WB);
	signal current_state, next_state: state_type;
	
	signal temp_ByteOp         : STD_LOGIC ;
	signal temp_MEM_WrEn       : std_logic;
	signal temp_ALU_func       : STD_LOGIC_VECTOR (3 downto 0);
	signal temp_ALU_Bin_sel    : STD_LOGIC ;
	signal temp_RF_B_sel       : STD_LOGIC ;
	signal temp_RF_WrEn        : STD_LOGIC ;
	signal temp_RF_WrData_sel  : STD_LOGIC ;
	signal temp_ImmExt         : STD_LOGIC_VECTOR (1 downto 0);
	signal temp_PC_sel         : STD_LOGIC ;
	-- ***NEW***
	signal temp_PC_LdEn        : STD_LOGIC ;
	signal temp_IR_WrEn			: STD_LOGIC ;
	signal OpCode				: STD_LOGIC_VECTOR(5 downto 0);
	
begin
	
	-- ***NEW***
	--**More like overhauled
	
	fsm_proc: process (Instruction, current_state, E, CLK, RST)
	begin
		OpCode <= Instruction(31 downto 26);
		case current_state is
			when RESET => 
				-- When reseting, go to FETCH state.
				next_state <= FETCH;	
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';
			-- Fetch state
			when FETCH =>
				next_state<=I_DEC;
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '1';
				temp_IR_WrEn 			<= '1';
				temp_RF_B_sel			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';
			-- Instruction decode
			when I_DEC => 
				-- LB, SB, LW, SW
				if (OpCode="000011" or OpCode="000111" or OpCode="001111" or OpCode="011111") then
					next_state <= MEM_EXEC;
					temp_RF_B_sel			<= '1';	
					temp_ImmExt				<= "10";			
				-- B, BEQ, BNE
				elsif (OpCode="111111" or OpCode="010000" or OpCode="010001") then
					next_state <= BRANCH_COMPL;
					temp_RF_B_sel			<= '1';
				-- For the rest of the instructions.
				else
					next_state <= R_EXEC;	
					temp_RF_B_sel<= '0';
					if (OpCode="111001") then
						temp_ImmExt			<= "01";
					elsif (OpCode="110000" OR OpCode ="111000") then
						temp_ImmExt			<= "10";
					else
						temp_ImmExt			<= "00";
					end if;
				end if;
				
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';
				
			when BRANCH_COMPL =>
			-- when we branch, we go back to Fetch state
			-- for the next instruction according to offset
				next_state <= FETCH;
				--check the new flag E register for BEQ and BNE
				--if E=1, we have equals, else not equals
				if ((OpCode="010000" and E='1') or (OpCode="010001" and E='0') or OpCode="111111") then
					temp_PC_sel 		<= '1';	-- (beq and E) or (bne and not E) or just branch
					temp_PC_LdEn 		<= '1';	
				else
					temp_PC_sel			<= '0';
					temp_PC_LdEn 		<= '0';	
				end if;
				
				temp_IR_WrEn 			<= '0';	
				temp_RF_B_sel			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ImmExt				<= "10";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';

			when R_EXEC =>
				next_state <= R_WB;	
				if (OpCode="100000") then --add, sub, and, not, or , sra, sll, srl, rol, ror
					temp_ALU_func		<= Instruction(3 downto 0);
				elsif (OpCode="111000") then	-- li
					temp_ALU_func		<= "0011"; 
				elsif (OpCode="111001") then	-- lui
					temp_ALU_func		<= "0011";
				elsif (OpCode="110000") then	-- addi
					temp_ALU_func		<= "0000";
				elsif (OpCode="110010") then	-- andi
					temp_ALU_func		<= "0101";
				elsif (OpCode="110011") then	-- ori
					temp_ALU_func		<= "0011";
				else
					temp_ALU_func		<= "0111";
				end if;
				if (OpCode="100000") then
					temp_ALU_Bin_sel	<= '0';
				else
					temp_ALU_Bin_sel	<= '1';
				end if;
				
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '1';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';

			when MEM_EXEC =>	
				--SB, SW we go to Store Memory state
				if (OpCode="000111" or OpCode="011111") then
					next_state <= S_MEM;
				else
				-- else we got Load Memory with LB, LW
					next_state <= L_MEM;
				end if;
				
				temp_ALU_func			<= "0000";	-- add
				temp_ALU_Bin_sel		<= '1';		-- immediate
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '1';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ImmExt				<= "00";
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';

			when R_WB =>
				-- This is write back to RF for R type instructions
				next_state <= FETCH;
				temp_RF_WrEn			<= '1';	-- write to RF
				temp_RF_WrData_sel		<= '0';	-- ALU_out
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';

			when S_MEM =>
				--Store memory state for sb, sw
				next_state <= FETCH;
				
				if (OpCode="000111") then
					temp_ByteOp			<= '1';
				else
					temp_ByteOp				<= '0';
				end if;
				temp_MEM_WrEn			<= '1';
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel	<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';

			when L_MEM =>
				-- Load memory state for lb, lw
				next_state <= L_WB;
				
				if (OpCode="000011") then
					temp_ByteOp			<= '1';
				else
					temp_ByteOp			<= '0';
				end if;
				temp_MEM_WrEn			<= '0';
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '0';
				temp_RF_WrEn			<= '0';
				temp_RF_WrData_sel		<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';

			when L_WB =>
				-- When we read from memory, then we want to write back
				-- to the registers of the RF.
				next_state <= FETCH;
				temp_RF_WrEn			<= '1';	
				temp_RF_WrData_sel		<= '1';	
				temp_PC_sel 			<= '0';
				temp_PC_LdEn 			<= '0';
				temp_IR_WrEn 			<= '0';
				temp_RF_B_sel			<= '0';
				temp_ImmExt				<= "00";
				temp_ALU_func			<= "0000";
				temp_ALU_Bin_sel		<= '0';
				temp_ByteOp				<= '0';
				temp_MEM_WrEn			<= '0';
		end case;
	end process fsm_proc;
	 
	 
	-- ***NEW***
	-- simple process for reseting the FSM and synchronizing it
	fsm_sync: process(CLK, RST)
	begin
		if (RST='1')  	   			then 	current_state <= RESET;  
		elsif (rising_edge(CLK))  	then	current_state <= next_state; 
     	end if;
	end process fsm_sync;

    ByteOp       <= temp_ByteOp;
    MEM_WrEn     <= temp_MEM_WrEn;
    ALU_func     <= temp_ALU_func;
    ALU_Bin_sel  <= temp_ALU_Bin_sel;
    RF_B_sel     <= temp_RF_B_sel;
    RF_WrEn      <= temp_RF_WrEn;
    RF_WrData_sel<= temp_RF_WrData_sel;
    ImmExt       <= temp_ImmExt;
    PC_sel       <= temp_PC_sel;
	-- ***NEW***
	PC_LdEn 	  <= temp_PC_LdEn;
  	IR_WrEn 	  <= temp_IR_WrEn;
end Behavioral;

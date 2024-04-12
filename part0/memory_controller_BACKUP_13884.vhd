----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:28 03/23/2024 
-- Design Name: 
-- Module Name:    memory_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity memory_controller is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
				AddrR: in STD_LOGIC_VECTOR(4 downto 0);
				AddrW: in STD_LOGIC_VECTOR(4 downto 0);
				Wf : in  STD_LOGIC;								-- Write input flag
           Rf: in  STD_LOGIC;									-- Read input flag
<<<<<<< HEAD
			  WEf: out STD_LOGIC;			-- Flag to enable write to RAM
			  val: out STD_LOGIC;
			  AddrOUT: out STD_LOGIC_VECTOR(4 downto 0)
=======
			  AddrOUT: out STD_LOGIC_VECTOR (4 downto 0);	-- Address to send to RAM to read/write
			  WEf: out STD_LOGIC;			-- Flag to enable write to RAM
			  Valid: out STD_LOGIC	  
>>>>>>> 3cf597a (States)
			  );								
end memory_controller;


architecture Behavioral of memory_controller is
	--Declaring states of the FSM.
	type state_type is (IDLE_STATE, WRITE_STATE, READ_STATE, READ_WRITE_STATE);
	signal state: state_type;
<<<<<<< HEAD
	signal rw_f: std_logic_vector(1 downto 0);
	signal rnw: std_logic;


begin
	
	rw_f <= (Rf, Wf);

	STATE_EN: process(rw_f, CLK)
	begin
	if rising_edge(CLK) then
		case rw_f is
			when "10" =>
				state <= READ_STATE;
			when "01" =>
				state <= WRITE_STATE;
			when "11" =>
				state <= READ_WRITE_STATE;
			when others =>
				state <= IDLE_STATE;
		end case;
	end if;
	end process;
	
	OUTPUT: process(state, AddrR)
	begin

		case state is
			when READ_STATE =>
				AddrOUT <= AddrR;
				WEf <= '0';
				val <= '1';
				rnw <= '0';
			when WRITE_STATE =>
				AddrOUT <= AddrW;
				val <= '0';
				WEf <= '1';		
				rnw <= '0';
			when READ_WRITE_STATE =>
				AddrOUT <= AddrR;
				WEf <= '0';
				val <= '1';
				rnw <= '1';
			when others =>
				WEf <= '0';
				val <= '0';
		end case;
		
		if (rnw = '1') then 
			AddrOUT <= AddrW;
			val <= '0';
			WEf <= '1';
		end if;
	end process;
	
	
=======
	
	signal rw_f: std_logic_vector(1 downto 0);

begin

	--MEALY State-Machine - Outputs based on state and inputs
	--others inputs to be added here.
--   MEM_CONTROL: process (state, Wf, Rf, AddrW, AddrR )
--   begin
--	--if(CLK'event and CLK = '1') then
--      if (Rf = '1' and Wf = '0') then
--		-- Read state
--			WEf <= '0';
--         AddrOUT <= AddrR;
--			Valid <= '1';
--			state <= READ_STATE;
--      elsif (Rf = '0' and Wf = '1') then
--		-- Write state
--			WEf <= '1';
--			AddrOUT <= AddrW;
--			Valid <= '0';
--			state <= WRITE_STATE;
--      elsif (Rf = '1' and Wf = '1') then
--		-- Read and Write state
--		-- The priority of the Read and Write state is first read and then write
--			WEf <= '0';
--			AddrOUT <= AddrR;
--			Valid <= '1';
--			
--			WEf <= '1';
--			AddrOUT <= AddrW;
--			Valid <= '0';
--			state <= READ_WRITE_STATE;
--		else
--		-- Idle state
--			WEf <= '0';
--			Valid <= '0';
--			--AddrOUT <= "00000";
--			state <= IDLE_STATE;
--      end if;
--	--end if;
--   end process;
	

	process( Wf, Rf)
	begin
		rw_f(1) <= Rf;
		rw_f(0) <= Wf;
	end process;

   MEM_CONTROL: process (state, rw_f, AddrW, AddrR )
   begin
	if (CLK'event and CLK = '1') then
      if (RST = '1') then
		-- Set to IDLE state
			state <= IDLE_STATE;
      else
			case rw_f is
				when "00" =>
					state <= IDLE_STATE;
				when "10" => 
					state <= READ_STATE;
				when "01" => 
					state <= WRITE_STATE;
				when "11" => 
					state <= READ_WRITE_STATE;
			end case;
		end if;
	end if;
   end process;
>>>>>>> 3cf597a (States)
	
end Behavioral;

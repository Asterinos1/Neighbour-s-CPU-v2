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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_controller is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           AddrWrite : in  STD_LOGIC_VECTOR (4 downto 0);
           AddrRead : in  STD_LOGIC_VECTOR (4 downto 0);
           Write : in  STD_LOGIC;
           Read : in  STD_LOGIC;
           NumberIN : in  STD_LOGIC_VECTOR (15 downto 0);
           NumberOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           Valid : out  STD_LOGIC);
end memory_controller;

architecture Behavioral of memory_controller is
	--Declaring states of the FSM.
	type state_type is (IDLE_STATE, WRITE_STATE, READ_STATE, READ_WRITE_STATE);
	signal state, next_state: state_type;

	--As shown in the Xilinx code examples.
begin
	sync_proc: process (CLK)
	begin
		if(CLK'event and CLK = '1')
			if (RST = '1') then
            state <= IDLE_STATE;
            <output> <= '0';
         else
            state <= next_state;
            <output> <= <output>_i;
         -- assign other outputs to internal signals
         end if;        
      end if;
   end process;
	
	--MEALY State-Machine - Outputs based on state and inputs
	--others inputs to be added here.
   OUTPUT_DECODE: process (state, Write, Read , ...)
   begin
      --insert statements to decode internal output signals
      --below is simple example
      if (state = st3_<name> and <input1> = '1') then
         <output>_i <= '1';
      else
         <output>_i <= '0';
      end if;
   end process;
	
	--inputs have to go here.
   NEXT_STATE_DECODE: process (state, Read, Write, ...)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when IDLE_STATE =>
            if <input_1> = '1' then
               next_state <= st2_<name>;
            end if;
         when st2_<name> =>
            if <input_2> = '1' then
               next_state <= st3_<name>;
            end if;
         when st3_<name> =>
            next_state <= IDLE_STATE;
         when others =>
            next_state <= IDLE_STATE;
      end case;      
   end process;

end Behavioral;


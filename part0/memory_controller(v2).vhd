library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity memory_controller is
    Port ( Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           WriteF : in  STD_LOGIC;
           ReadF : in  STD_LOGIC;
           AddrR : in  STD_LOGIC_VECTOR (4 downto 0);
			  AddrW : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : in  STD_LOGIC_VECTOR (15 downto 0);
           AddrOUT : out  STD_LOGIC_VECTOR (4 downto 0);
           DataOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           WEf : out  STD_LOGIC);
end memory_controller;

architecture Behavioral of memory_controller is
	type t_state is (IDLE_S, READ_S,WRITE_S,READ_WRITE_S);
	signal state, next_state: t_state;
begin
	--synchronous process.
   SYNC_PROC: process (Clk)
   begin
      if (Clk'event and Clk = '1') then
         if (Rst = '1') then
            state <= IDLE_S;
				--Do nothing.
            --<output> <= '0';
         else
            state <= next_state;
         --   <output> <= <output>_i;
         -- assign other outputs to internal signals
         end if;        
      end if;
   end process;
	
	 --MEALY State-Machine - Outputs based on state and inputs
   OUTPUT_DECODE: process (state, ReadF, WriteF)
   begin
		if(state = IDLE_S) then
			--AddrOUT<=Addr;
			--WEf<='0';
		elsif(state = READ_S and ReadF='1') then
			AddrOUT<=AddrR;
			WEf<='0';
		elsif(state = WRITE_S and WriteF='1') then
			WEf<='1';
			AddrOUT<=AddrW;
			DataOUT<=Data;
		elsif(state = READ_WRITE_S and ReadF='1' and WriteF='1') then
			WEf<='0';	
		end if;	
 
   end process;
 
   NEXT_STATE_DECODE: process (state, WriteF, ReadF)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when IDLE_S =>
            if ReadF = '1' and Writef='0' then
               next_state <= READ_S;
            elsif ReadF = '0' and WriteF='1' then
					next_state <= WRITE_S;
				elsif ReadF = '1' and WriteF='1' then	
					next_state <= READ_WRITE_S;
				elsif ReadF = '0' and WriteF='0' then
					next_state <= IDLE_S;
				end if;
         when READ_S =>
            if ReadF = '1' and Writef='0' then
               next_state <= READ_S;
            elsif ReadF = '0' and WriteF='1' then
					next_state <= WRITE_S;
				elsif ReadF = '1' and WriteF='1' then	
					next_state <= READ_WRITE_S;
				elsif ReadF = '0' and WriteF='0' then
					next_state <= IDLE_S;
				end if;
         when WRITE_S =>
				if ReadF = '1' and Writef='0' then
               next_state <= READ_S;
            elsif ReadF = '0' and WriteF='1' then
					next_state <= WRITE_S;
				elsif ReadF = '1' and WriteF='1' then	
					next_state <= READ_WRITE_S;
				elsif ReadF = '0' and WriteF='0' then
					next_state <= IDLE_S;
				end if;
         when READ_WRITE_S =>
            if ReadF = '1' and Writef='0' then
               next_state <= READ_S;
            elsif ReadF = '0' and WriteF='1' then
					next_state <= WRITE_S;
				elsif ReadF = '1' and WriteF='1' then	
					next_state <= READ_WRITE_S;
				elsif ReadF = '0' and WriteF='0' then
					next_state <= IDLE_S;
				end if;
      end case;      
   end process;
	
end Behavioral;


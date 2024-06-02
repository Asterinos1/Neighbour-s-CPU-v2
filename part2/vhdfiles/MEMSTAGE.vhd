library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity MEMSTAGE is
    Port ( ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);	
           MM_WrEn : out  STD_LOGIC;
           MM_Addr : out  STD_LOGIC_VECTOR (9 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is

begin
	process(ByteOp,Mem_WrEn,ALU_MEM_Addr,MEM_DataIn,MM_RdData)
	begin
		MM_WrEn <= Mem_WrEn;		
		MM_Addr <= ALU_MEM_Addr(11 downto 2); 	
		if(ByteOp = '1') then
			if(ALU_MEM_Addr(1 downto 0)="00") then
				MM_WrData <= (MM_RdData(31 downto 8) &  MEM_DataIn(7 downto 0));
				MEM_DataOut <= (x"000000" & MM_RdData(7 downto 0));
			elsif(ALU_MEM_Addr(1 downto 0)="01") then
				MM_WrData <= (MM_RdData(31 downto 16) &  MEM_DataIn(7 downto 0) & MM_RdData(7 downto 0));
				MEM_DataOut <= (x"000000" & MM_RdData(15 downto 8));		
			elsif(ALU_MEM_Addr(1 downto 0)="10") then
				MM_WrData <= (MM_RdData(31 downto 24) &  MEM_DataIn(7 downto 0) & MM_RdData(15 downto 0));
				MEM_DataOut <= (x"000000" & MM_RdData(23 downto 16));		
			elsif(ALU_MEM_Addr(1 downto 0)="11") then
				MM_WrData <= (MEM_DataIn(7 downto 0) & MM_RdData(23 downto 0));
				MEM_DataOut <= (x"000000" & MM_RdData(31 downto 24));
			else
				MM_WrData <= "00000000000000000000000000000000";
				MEM_DataOut <= "00000000000000000000000000000000";
			end if;	
		else
			MM_WrData <= MEM_DataIn;
			MEM_DataOut <= MM_RdData;
		end if;
	end process;
end Behavioral;


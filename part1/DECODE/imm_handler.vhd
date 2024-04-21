library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imm_handler is
    Port ( opcode : in  STD_LOGIC_VECTOR (1 downto 0);
           imm_in : in  STD_LOGIC_VECTOR (15 downto 0);
           imm_out : out  STD_LOGIC_VECTOR (31 downto 0));
end imm_handler;

architecture Behavioral of imm_handler is

	signal intermediate_imm: STD_LOGIC_VECTOR (31 downto 0);

begin
	calibrate: process(imm_in, opcode)
	begin
		
		case opcode is
			when "00" =>	-- zerofill, no shift
				intermediate_imm <= x"0000" & imm_in;
			when "01" =>	-- zerofill, shift (basically just left (logical) shift by 16)
				intermediate_imm <= imm_in & x"0000";
			when "10" =>	-- sign extend, no shift
				intermediate_imm (15 downto 0) <= imm_in;
				intermediate_imm (31 downto 16)<= (others => imm_in(15));
			when "11" =>	-- sign extend, shift
				intermediate_imm (15 downto 0) <= imm_in;
				intermediate_imm (31 downto 16)<= (others => imm_in(15));
				--intermediate_imm <= intermediate_imm(29 downto 0) & "00";
			when others =>	-- do nothing
				null;
		end case;
	end process;

	imm_out <= (intermediate_imm(29 downto 0) & "00") when opcode="11" else intermediate_imm;	-- shift here, because in line 59's intermediate_imm as an rvalue ignored the changes in the 2 lines above
	
end Behavioral;


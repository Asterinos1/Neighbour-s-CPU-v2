library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity im_mod is
    Port ( opcode : in  STD_LOGIC_VECTOR (1 downto 0);
           imm_in : in  STD_LOGIC_VECTOR (15 downto 0);
           imm_out : out  STD_LOGIC_VECTOR (31 downto 0));
end im_mod;

architecture Behavioral of im_mod is
	signal temp: std_logic_vector(31 downto 0);
begin
	process(imm_in, opcode)
	begin
		case opcode is
			when "00" =>	
				-- simple zero fill
				temp <= x"0000" & imm_in;
			when "01" =>	
				-- zerofill with left logical shift
				temp <= imm_in & x"0000";
			when "10" =>	
				-- sign extention without no shift
				temp (15 downto 0) <= imm_in;
				temp (31 downto 16)<= (others => imm_in(15));
			when "11" =>	
				-- sign extend with shift
				temp (15 downto 0) <= imm_in;
				temp (31 downto 16)<= (others => imm_in(15));
				
			when others =>	
				-- do nothing
				null;
		end case;
	end process;
	
	-- troubleshoot line
	-- shift here, because in line 59's intermediate_imm as an rvalue ignored the changes in the 2 lines above
	imm_out <= (temp(29 downto 0) & "00") when opcode="11" else temp;

end Behavioral;


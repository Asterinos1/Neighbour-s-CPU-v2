library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.arr_vector32.all;

entity register_file is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           WrEn : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));
end register_file;

architecture Behavioral of register_file is
	
	-- Decoder part
	component decoder_5_32
	port(
		input: in std_logic_vector(4 downto 0);
		output : out  std_logic_vector(31 downto 0)
	);
	end component;
	
	-- signal to handle decoder output
	signal dec_out: std_logic_vector(31 downto 0);
	
	
	-- registers multiplexer part
	component reg_mux
	port(
		input: in arr_v32(0 to 31);
		sel: in integer range 0 to 31;
		output: out std_logic_vector(31 downto 0)
	);
	end component;

	-- Signal to handle the two registers muxs's inputs
	signal reg_mux_input: arr_v32(0 to 31):=(others => (others=>'0'));
	
	
	-- Register part
	component basic_register
	port(
		CLK : IN  std_logic;
      WE : IN  std_logic;
      Datain : IN  std_logic_vector(31 downto 0);
      RST : IN  std_logic;
      Dataout : OUT  std_logic_vector(31 downto 0)
	);
	end component;
	
	--to be tested
	signal intermediate_WE_array: std_logic_vector(31 downto 0):=(others=>'0');
	
	
	-- output mux
	component out_mux
	port(
		input_1 : IN  std_logic_vector(31 downto 0);
		input_2 : IN  STD_LOGIC_VECTOR (31 downto 0);
      sel_2 : IN  std_logic;
      output_2 : OUT  std_logic_vector(31 downto 0)
	);
	end component;
	
	-- signals to handle the two output muxs outputs
	signal out_mux_output_1: std_logic_vector(31 downto 0);
	signal out_mux_output_2: std_logic_vector(31 downto 0);
	
	--compare modules part
	COMPONENT compare_module
	PORT (
			inp : IN STD_LOGIC_VECTOR (4 downto 0);
			inp2 : IN STD_LOGIC_VECTOR (4 downto 0);
			we : IN  std_logic;
			outp: OUT  std_logic
		  );
	END COMPONENT;
		  
	signal comp_mod_out1: std_logic;
	signal comp_mod_out2: std_logic;
begin
	dec: decoder_5_32 port map(
		input=> Awr,
		output => dec_out
	);
	
	reg_mux_1: reg_mux port map(
		input => reg_mux_input,
		sel => conv_integer(Ard1),
		output => out_mux_output_1
	);
	
	reg_mux_2: reg_mux port map(
		input => reg_mux_input,
		sel => conv_integer(Ard2),
		output => out_mux_output_2
	);
	
	cmp_mod_1: compare_module port map(
		inp => Awr,
		inp2 => Ard1,
		we => WrEn,
		outp => comp_mod_out1
	);
	
	cmp_mod_2: compare_module port map(
		inp => Awr,
		inp2 => Ard2,
		we => WrEn,
		outp => comp_mod_out2
	);
	
	outmux_1: out_mux port map(
		input_1 => out_mux_output_1,
		input_2 => Din,
		sel_2 => comp_mod_out1,
		output_2 => Dout1
	);
	
	outmux_2: out_mux port map(
		input_1 => out_mux_output_2,
		input_2 => Din,
		sel_2 => comp_mod_out2,
		output_2 => Dout2
	);
	
	generating_registers: for i in 0 to 31 generate
		r_zero: if i=0 generate
			R0:basic_register port map(
				CLK => Clock,					-- Clock goes straight to the registers
				WE => '0',						-- R0 cannot be overwritten
				Datain => (others => '0'),	-- R0 is hard wired to 0
				RST => RST,						-- RST goes straight to the registers (and resets them all, high triggered)
				Dataout => reg_mux_input(i)
			);
		end generate r_zero;
		
		other_registers: if i>0 generate
			RX: basic_register port map(
				CLK => Clock,							-- Clock goes straight to the registers 
				WE => intermediate_WE_array(i),	
				Datain => Din,							-- Din goes straight to the registers
				RST => RST,								-- RST goes straight to the registers (and resets them all, high triggered)
				Dataout => reg_mux_input(i)				-- register outs go to mux input
			);
		end generate other_registers;
	end generate generating_registers;
	
	process(Clock, Ard1, Ard2, Awr, WrEn, RST, Din,dec_out) 
	begin
	
		--if rising_edge(Clock) then
			-- RST case is already handled (we have passed RST to the registers straight,so just deal with the other cases)
			if RST='0' then
				-- just refresh the write enable array
				write_enable_loop: for j in 0 to 31 loop
					intermediate_WE_array(j) <= WrEn and dec_out(j); 
				end loop write_enable_loop;				
			end if;
		--end if;   
	
	end process;

end Behavioral;


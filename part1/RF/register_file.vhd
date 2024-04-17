library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrices.all;

entity register_file is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEN : in  STD_LOGIC;
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));
end register_file;

architecture Behavioral of register_file is
	--declaring register
	component basic_register 
	port(
		DataIN : in  STD_LOGIC_VECTOR (31 downto 0);
      CLK : in  STD_LOGIC;
      RST : in  STD_LOGIC;
      WE : in  STD_LOGIC;
      DataOUT : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	-- This is an intermediate register WE signal, whose values refresh with
	-- each clock cycle.
	signal intermediate_WE_array: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


	--declaring decoder
	component decoder 
	port(
		dec_in: in std_logic_vector(4 downto 0);
		dec_out: out std_logic_vector(31 downto 0)
		);
	end component;
	-- signal to handle decode'r output
	signal decout: std_logic_vector(31 downto 0);
	
	
	
	--declaring register multiplexers
	component reg_mux
	port(
		reg_in: in MATRIX(0 to 31);
		sel: in integer range 0 to 31;
		reg_out: out std_logic_vector(31 downto 0)
		);
	end component;
	-- signal to handle both multiplexers's inputs.
	signal reg_mux_in: MATRIX(0 to 31):= (others => (others => '0'));
	--declaring signals to handle each multiplexer's output.
	signal reg_mux_out1: std_logic_vector(31 downto 0);
	signal reg_mux_out2: std_logic_vector(31 downto 0);
	
	
	--declaring multiplexers for RF outputs.
	component mux_out
	port(
		in1 : in  STD_LOGIC_VECTOR (31 downto 0);
      in2 : in  STD_LOGIC_VECTOR (31 downto 0);
      sel : in  STD_LOGIC;
      output : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	--declaring compare module
	component compare 
	port(
		ard_in : in  STD_LOGIC_VECTOR (4 downto 0);
      awr_in : in  STD_LOGIC_VECTOR (4 downto 0);
      WE : in  STD_LOGIC;
      cmp_out : out  STD_LOGIC
		);
	end component;
	
	--Declaring signals to handle each compare module's output
	signal cmp_out1: std_logic;
	signal cmp_out2: std_logic;	
	
begin
	--declaring the 5 to 32 decoder.
	decoder1 : decoder port map(
								dec_in => Awr,
								dec_out => decout
							 ); --assing decoder's output to the custom signal
	
	
	--declaring registers
	--Using VHDL's generate, we create 32 instances for component basic_register
	create_registers: for i in 0 to 31 generate
		
		--We want our first register (R0) to always be 0
		R_Zero: if i=0 generate
			R0: basic_register PORT MAP(
					CLK => CLK,					
					WE => '0',						
					Datain => (others => '0'),	-- R0 is hard wired to 0
					RST => RST,						
					Dataout => reg_mux_in(i)
				);
		end generate R_Zero;
		
		other_regs: if i>0 generate
			regx: basic_register PORT MAP(
					CLK => CLK,							 
					WE => intermediate_WE_array(i),	
					Datain => Din,							-- Din goes straight to the registers
					RST => RST,								
					Dataout => reg_mux_in(i)				-- register outs go to reg_mux input
				);
		end generate other_regs;
	end generate create_registers;
	
	--declaring the first 2 multiplexers.
	reg_mux_1: reg_mux port map(
								reg_in => reg_mux_in,
								sel => conv_integer(Ard1),
								reg_out => reg_mux_out1
							 );
	reg_mux_2: reg_mux port map(
								reg_in => reg_mux_in,
								sel => conv_integer(Ard1),
								reg_out => reg_mux_out2
							 );
							
	--declaring compare modules
	compare_module1: compare port map(
										ard_in => Ard1,
										awr_in => Awr,
										WE => WrEN,
										cmp_out => cmp_out1
							       );
									 
	compare_module2: compare port map(
										ard_in => Ard2,
										awr_in => Awr,
										WE => WrEN,
										cmp_out => cmp_out2
							       );	
									 
	--declaring RF output multiplexers
	mux_1_out: mux_out port map(
								in1=> reg_mux_out1,
								in2=> Din,
								sel=> cmp_out1,
								output=> Dout1
							 );
	mux_2_out: mux_out port map(
								in1=> reg_mux_out2,
								in2=> Din,
								sel=> cmp_out2,
								output=> Dout2
							 );
							 
						 
					
	process(CLK, Ard1, Ard2, Awr, WrEn, RST, Din,decout) 
	begin
	
		--if rising_edge(Clock) then
			-- RST case is already handled (we have passed RST to the registers straight,so just deal with the other cases)
			if RST='0' then
				-- just refresh the write enable array
				write_enable_loop: for j in 0 to 31 loop
					intermediate_WE_array(j) <= WrEn and decout(j); 
				end loop write_enable_loop;				
			end if;
		--end if;   
	
	end process;					 
							 
end Behavioral;


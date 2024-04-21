library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.matrices.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


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


	-- Decoder declaration
	COMPONENT decoder 
	PORT(
         decIn : IN  std_logic_vector(4 downto 0);
         decOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
 	-- Decoder Output (decOut) will be "redirected" to dec_out
   signal dec_out: std_logic_vector(31 downto 0);
	
	
	
	-- Multiplexer declaration
	COMPONENT generic_mux
	PORT (
         input : IN  MATRIX(0 to 31);
         sel : IN  integer range 0 to 31;
         output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	-- The inputs of the 2 multiplexers' are the same, and are the register outputs.
	signal mux_input : MATRIX(0 to 31) := (others => (others => '0'));

	


	-- Register declaration
	COMPONENT reg
	PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         Datain : IN  std_logic_vector(31 downto 0);
         RST : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
	END COMPONENT;
	-- This is an intermediate register WE signal, whose values refresh with
	-- each clock cycle.
	signal intermediate_WE_array: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
	
	
	
   -- Multiplexer declaration
	COMPONENT s_mux
	PORT (
         input_1 : IN  std_logic_vector(31 downto 0);
			input_2 : IN  STD_LOGIC_VECTOR (31 downto 0);
         sel_2 : IN  std_logic;
         output_2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 -- Signals to handle each multiplexer's output
	signal mux_output_1 : std_logic_vector(31 downto 0);
	signal mux_output_2 : std_logic_vector(31 downto 0);
	
	
	-- Compare module declaration
	COMPONENT compare_module
	PORT (
			inp : IN STD_LOGIC_VECTOR (4 downto 0);
			inp2 : IN STD_LOGIC_VECTOR (4 downto 0);
			we : IN  std_logic;
			outp: OUT  std_logic
		  );
	END COMPONENT;
	-- Signals  to handle each compare module's output
	signal comp_mod_out1: std_logic;
	signal comp_mod_out2: std_logic;
	
begin
	-- iinstantiation of the decoder
	dec:	decoder PORT MAP (
				A => Awr,
				X => dec_out 
			);

	-- instantiation of the multiplexers		
	reg_mux1: generic_mux PORT MAP (
				input => mux_input,
				sel => conv_integer(Ard1),
				output => mux_output_1
			);	
	
	reg_mux2: generic_mux PORT MAP (
				input => mux_input,
				sel => conv_integer(Ard2),
				output => mux_output_2
			);
			
	compare_module_1: compare_module PORT MAP (
				inp => Awr,
				inp2 => Ard1,
				we => WrEn,
				outp => comp_mod_out1
			);
			
	compare_module_2: compare_module PORT MAP (
				inp => Awr,
				inp2 => Ard2,
				we => WrEn,
				outp => comp_mod_out2
			);
			
	mux_out_1: s_mux PORT MAP (
				input_1 => mux_output_1,
				input_2 => Din,
				sel_2 => comp_mod_out1,
				output_2 => Dout1
			);	
			
	mux_out_2: s_mux PORT MAP (
				input_1 => mux_output_2,
				input_2 => Din,
				sel_2 => comp_mod_out2,
				output_2 => Dout2
			);	
			
	-- Generating registers using VHDL's generate function
	create_registers: for i in 0 to 31 generate
		
		R_Zero: if i=0 generate
			R0: reg PORT MAP(
					CLK => Clock,					
					WE => '0',						-- R0 cannot be overwritten
					Datain => (others => '0'),	-- R0 is set to 0 (permanently)
					RST => RST,						-- RST goes straight to the registers
					Dataout => mux_input(i)    -- register output go to mux input (the MATRIX we created)
		end generate R_Zero;
		
		other_regs: if i>0 generate
			regx: reg PORT MAP(
					CLK => Clock,						
					WE => intermediate_WE_array(i),	-- Connecting the WE of each register to the array we declared earlier
					Datain => Din,							-- Din goes straight to the registers
					RST => RST,								-- RST goes straight to the registers
					Dataout => mux_input(i)				-- registers outs go to mux input (the MATRIX we created)
				);
		end generate other_regs;
	end generate create_registers;


	process(Clock, Ard1, Ard2, Awr, WrEn, RST, Din,dec_out) 
	begin
	
		--if rising_edge(Clock) then
			-- RST case is already handled inside the registers
			if RST='0' then
				-- Loop through the WE handling array 
				write_enable_loop: for j in 0 to 31 loop
					-- Performing logical AND between WrEN and the Decoder's output
					intermediate_WE_array(j) <= WrEn and dec_out(j); 
				end loop write_enable_loop;				
			end if;
		--end if;   
	
	end process;


end Behavioral;



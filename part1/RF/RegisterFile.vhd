----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:41:13 04/14/2023 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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

library WORK;
use WORK.ARRAY_IO_32.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is

	component basic_register
		port ( rin : in STD_LOGIC_VECTOR (31 downto 0);
				 we :  STD_LOGIC;
				 clk : in STD_LOGIC;
				 rout : STD_LOGIC_VECTOR (31 downto 0);
				 reset : STD_LOGIC
				 );
	end component;

	component decoder_5_to_32
		port ( d_in : in STD_LOGIC_VECTOR (4 downto 0);
				 d_out : STD_LOGIC_VECTOR (31 downto 0)
			    );
	end component;
	
	component compare_module
		port ( cmp_0 : in STD_LOGIC_VECTOR (4 downto 0);
				 cmp_1 : in STD_LOGIC_VECTOR (4 downto 0);
				 result : STD_LOGIC_VECTOR (4 downto 0)
				 );
	end component;
	
	component MUX_32_32
		port ( m_in : arr_io;
				 sel : STD_LOGIC_VECTOR (4 downto 0);
				 m_out : STD_LOGIC_VECTOR (31 downto 0)
				 );
	end component;
	
	--
	signal dec_res : STD_LOGIC_VECTOR (31 downto 0);
	signal reg_in : STD_LOGIC_VECTOR (31 downto 0);
	
	-- Array of the Registers output to connect to the Multiplexers
	signal mux_in : arr_io;
	
	-- Connection between the 32to1 MUX and the 2to1 MUX
	signal mux_con_0 : STD_LOGIC_VECTOR (31 downto 0);
	signal mux_con_1 : STD_LOGIC_VECTOR (31 downto 0);
	
	-- Outputs of the compare module
	signal cm_res_0 : STD_LOGIC_VECTOR (4 downto 0);
	signal cm_res_1 : STD_LOGIC_VECTOR (4 downto 0);
	
begin

	--Instantiaton of the 5 to 32 decoder
	Dec : decoder_5_to_32
		port map ( d_in => Awr,
					  d_out => dec_res
					  );
					  
	--Pass all the signals from the decoder through an and gate 
	process(reg_in, dec_res, WrEn)
	begin
		for i in 31 to 0 loop
			reg_in(i) <= dec_res(i) and WrEn;
		end loop;
	end process;
	

	-- Instantiation of the 32 registers
   --Register 0
	R0 : basic_register
        port map ( 
            rin => b"0000_0000_0000_0000_0000_0000_0000_0000",
            we => reg_in(0),
            clk => CLK,
            rout => mux_in(0),
				reset => '0'
        );
		  
	--Instantiate the rest of the registers  
	inst_reg : for i in 31 to 1 generate
		
		RX : basic_register
			port map ( rin => Din,
						  we => reg_in(i),
						  clk => CLK,
						  rout => mux_in(i),
						  reset => '0'
						  );
	end generate;
				

	--Instantiation of the 2 32to1 Multiplexers
	MUX_32_0 : MUX_32_32
		port map ( m_in => mux_in,
					  sel => Ard1,
					  m_out => mux_con_0
					  );
		
	MUX_32_1 : MUX_32_32
		port map ( m_in => mux_in,
					  sel => Ard2,
					  m_out => mux_con_1
					  );

	--Instantiation of the 2 compare modules
	cm_0: compare_module
		port map ( cmp_0 => Ard1,
					  cmp_1 => Awr,
					  result => cm_res_0
					  );
	cm_1: compare_module
		port map ( cmp_0 => Ard2,
					  cmp_1 => Awr,
					  result => cm_res_1
					  );
	
	Dout1 <= mux_con_0 when cm_res_0 = b"0" else
			   Din;
				
	Dout2 <= mux_con_1 when cm_res_1 = b"0" else
				Din;

end Behavioral;


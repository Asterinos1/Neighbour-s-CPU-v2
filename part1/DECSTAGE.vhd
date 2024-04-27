----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:52:43 04/27/2024 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
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

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_Sel : in  STD_LOGIC;
           RF_B_Sel : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  RESET : in STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end DECSTAGE;

architecture Behavioral of DECSTAGE is

	COMPONENT register_file
	PORT(
		Ard1 : IN std_logic_vector(4 downto 0);
		Ard2 : IN std_logic_vector(4 downto 0);
		Awr : IN std_logic_vector(4 downto 0);
		WrEn : IN std_logic;
		Clock : IN std_logic;
		RST : IN std_logic;
		Din : IN std_logic_vector(31 downto 0);          
		Dout1 : OUT std_logic_vector(31 downto 0);
		Dout2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT MUX_5_2
	PORT(
		In0 : IN std_logic_vector(4 downto 0);
		In1 : IN std_logic_vector(4 downto 0);
		Sel : IN std_logic;          
		M_Out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	signal reg_mux_res : STD_LOGIC_VECTOR(31 downto 0);

	COMPONENT s_mux
	PORT(
		input_1 : IN std_logic_vector(31 downto 0);
		input_2 : IN std_logic_vector(31 downto 0);
		sel_2 : IN std_logic;          
		output_2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	signal wr_mux_res : STD_LOGIC_VECTOR(31 downto 0);
	
	COMPONENT Instr_ext
	Port(
		Opcode : IN std_logic_vector(1 downto 0);
		Instr : IN std_logic_vector(15 downto 0);
		Immed : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
		
begin
 
	RF: register_file PORT MAP(
		Ard1 => Instr(25 downto 21),
		Ard2 => reg_mux_res,
		Awr => Instr(20 downto 16),
		WrEn => RF_WrEn,
		Clock => CLK,
		RST => RESET,
		Din => wr_mux_res,
		Dout1 => RF_A,
		Dout2 => RF_B
	);
	
	R_MUX: MUX_5_2 PORT MAP(
		In0 => Instr(15 downto 11),
		In1 => Instr(20 downto 16),
		Sel => RF_B_Sel,
		M_Out => reg_mux_res
	);
	
	WData_MUX: s_mux PORT MAP (
		input_1 => MEM_Out,
		input_2 => ALU_Out,
		sel_2 => RF_WrData_Sel,
		output_2 => wr_mux_res
	);
	
	i_ext: Instr_ext PORT MAP (
		Opcode => Instr(31 downto 30),
		Instr => Instr(15 downto 0),
		Immed => Immed
	);

end Behavioral;


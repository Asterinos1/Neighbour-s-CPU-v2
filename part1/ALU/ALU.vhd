----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:00:39 04/10/2023 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Stractural of ALU is
	SIGNAL logOutput : STD_LOGIC_VECTOR (31 downto 0);--output for logical_ALU.
	SIGNAL  logZero :   STD_LOGIC; -- logZero, logCout, logOvf for logical_ALU.
	SIGNAL  logCout :   STD_LOGIC;
	SIGNAL  logOvf :   STD_LOGIC;
	SIGNAL  asOvf :   STD_LOGIC;-- asOvf, asCout, asZero for add_sub_ALU.
	SIGNAL  asCout :   STD_LOGIC;
	SIGNAL  asZero :   STD_LOGIC; 
	SIGNAL asOutput : STD_LOGIC_VECTOR (31 downto 0); --output for add_sub_ALU.
	SIGNAL  shZero :   STD_LOGIC;-- shZero, shCout, shOvf for shift_ALU.
	SIGNAL  shCout :   STD_LOGIC;
	SIGNAL  shOvf :   STD_LOGIC;
	SIGNAL shOutput : STD_LOGIC_VECTOR (31 downto 0);--output for shift_ALU.

	Component add_sub_ALU is
		Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
			B : in  STD_LOGIC_VECTOR (31 downto 0);
			Op : in  STD_LOGIC_VECTOR (3 downto 0);
			Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
			Zero : out  STD_LOGIC;
			Cout : out  STD_LOGIC;
			Ovf : out  STD_LOGIC);
	end Component;	

	Component logical_ALU is
		Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
			B : in  STD_LOGIC_VECTOR (31 downto 0);
			Op : in  STD_LOGIC_VECTOR (3 downto 0);
			Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
			Zero : out  STD_LOGIC;
			Cout : out  STD_LOGIC;
			Ovf : out  STD_LOGIC);
	end Component;	

	Component shift_ALU is
		Port(A : in  STD_LOGIC_VECTOR (31 downto 0);
			B : in  STD_LOGIC_VECTOR (31 downto 0);
			Op : in  STD_LOGIC_VECTOR (3 downto 0);
			Out_1 : out  STD_LOGIC_VECTOR (31 downto 0);
			Zero : out  STD_LOGIC;
			Cout : out  STD_LOGIC;
			Ovf : out  STD_LOGIC);
	end Component;
			 
begin
	--creating port maps for componenets.
   add_sub: add_sub_ALU PORT MAP(A => A, 
	B => B, 
	Op => Op, 
	Out_1 => asOutput, 
	Zero => asZero, 
	Cout =>asCout, 
	Ovf => asOvf);
	
   logical: logical_ALU PORT MAP(A => A,
	B => B,
	Op => Op,
	Out_1 => logOutput,
	Zero => logZero,
	Cout => logCout,
	Ovf => logOvf);
								  
	shift: shift_ALU PORT MAP(A => A,
	B => B,
	Op => Op,
	Out_1 => shOutput,
	Zero => shZero,
	Cout => shCout,
	Ovf => shOvf);	  
	
	--get the desired output according to Op
	Out_1 <= asOutput when Op = "0000" OR Op = "0001" else
					logOutput when Op = "0010" OR Op = "0011" OR Op = "0100" else
					shOutput when Op = "1000" OR Op = "1001" OR Op = "1010" OR Op = "1100" OR Op = "1101";
	--get zero
	Zero <= asZero when Op = "0000" OR Op = "0001" else
				logZero when Op = "0010" OR Op = "0011" OR Op = "0100" else
				shZero when Op = "1000" OR Op = "1001" OR Op = "1010" OR Op = "1100" OR Op = "1101";
	--get cout
	Cout <= asCout when Op = "0000" OR Op = "0001" else
					logCout when Op = "0010" OR Op = "0011" OR Op = "0100" else
					shCout when Op = "1000" OR Op = "1001" OR Op = "1010" OR Op = "1100" OR Op = "1101";
	--get overflow
	Ovf <= asOvf when Op = "0000" OR Op = "0001" else
					logOvf when Op = "0010" OR Op = "0011" OR Op = "0100" else
					shOvf when Op = "1000" OR Op = "1001" OR Op = "1010" OR Op = "1100" OR Op = "1101";
	
end Stractural;

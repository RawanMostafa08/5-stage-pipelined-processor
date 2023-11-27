LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY exec_mem IS
	PORT (
		aluResIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		destRegIn1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		destRegIn2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeBackIn : IN STD_LOGIC;
		destRegOut1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		destRegOut2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		aluResOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeBackOut : OUT STD_LOGIC
	);
END exec_mem;

ARCHITECTURE arch_exec_mem OF exec_mem IS
BEGIN
	aluResOut <= aluResIn;
	destRegOut1 <= destRegIn1;
	destRegOut2 <= destRegIn2;
	writeBackOut <= writeBackIn;

END arch_exec_mem;
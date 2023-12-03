LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY exec_mem IS
	PORT (
		aluResult : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeBack0 : INOUT STD_LOGIC;
		writeBack1 : INOUT STD_LOGIC
	);
END exec_mem;

ARCHITECTURE arch_exec_mem OF exec_mem IS
BEGIN
END arch_exec_mem;
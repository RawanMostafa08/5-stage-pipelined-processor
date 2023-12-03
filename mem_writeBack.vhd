LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY mem_writeBack IS
	PORT (
		resMem : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg1 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeBack0 : INOUT STD_LOGIC;
		writeBack1 : INOUT STD_LOGIC;
		memReg : INOUT STD_LOGIC
	);
END mem_writeBack;

ARCHITECTURE arch_mem_writeBack OF mem_writeBack IS
BEGIN

END arch_mem_writeBack;
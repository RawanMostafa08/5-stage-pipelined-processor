LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY mem_writeBack IS
	PORT (
		resMemIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAluIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeBackIn : IN STD_LOGIC;
		memRegIn : IN STD_LOGIC;
		resMemOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAluOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeBackOut : OUT STD_LOGIC;
		memRegOut : OUT STD_LOGIC
	);
END mem_writeBack;

ARCHITECTURE arch_mem_writeBack OF mem_writeBack IS
BEGIN
	resMemOut <= resMemIn;
	resAluOut <= resAluIn;
	memRegOut <= memRegIn;
	writeBackOut <= writeBackIn;

END arch_mem_writeBack;
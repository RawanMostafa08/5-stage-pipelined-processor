LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY writeBack IS
	PORT (
		resMem          : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu          : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		swapAlu         : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReg          : IN STD_LOGIC;
		swap            : IN STD_LOGIC;
		Swap_Out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		res             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		inPort          : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReg_in_instr : IN STD_LOGIC
	);
END writeBack;

ARCHITECTURE archWriteBack OF writeBack IS
BEGIN
	res <=
		resMem WHEN memReg = '0' AND swap = '0'AND memReg_in_instr = '0'
		ELSE
		resAlu WHEN memReg_in_instr = '0' AND (memReg = '1' OR swap = '1')
		ELSE
		inPort WHEN memReg_in_instr = '1' AND memReg = '0';
	Swap_Out <= swapAlu;
END archWriteBack;
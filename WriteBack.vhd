LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY writeBack IS
	PORT (
		resMem : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReg : IN STD_LOGIC;
		res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END writeBack;

ARCHITECTURE archWriteBack OF writeBack IS
BEGIN
	res <=
		resMem WHEN memReg = '0'
		ELSE
		resAlu;

END archWriteBack;
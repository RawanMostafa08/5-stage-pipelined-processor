LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY memory IS
	PORT (
		address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memRead : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		aluData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END memory;

ARCHITECTURE archMemory OF memory IS
BEGIN
	aluData <= address;

END archMemory;
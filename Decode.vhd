LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY decode IS
	PORT (
		readReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		readReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeBack : IN STD_LOGIC;
		readData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		-- readData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END decode;

ARCHITECTURE archDecode OF decode IS
	TYPE reg IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL regFile : reg;
BEGIN

regFile(to_integer(unsigned((writeReg1))))<=(OTHERS => '0');
regFile(to_integer(unsigned((writeReg1))))<=writeData2 when writeBack='1';
regFile(to_integer(unsigned((writeReg1))))<=writeData1 when writeBack='1';




readData1 <= regFile(to_integer(unsigned((readReg1))));
readData2 <= regFile(to_integer(unsigned((readReg2))));



END archDecode;
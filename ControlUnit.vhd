LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY controlUnit IS
	PORT (
		opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		memReg : OUT STD_LOGIC;
		writeBack : OUT STD_LOGIC;
		execSig : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)

	);
END controlUnit;

ARCHITECTURE archControlUnit OF controlUnit IS
BEGIN
	PROCESS (opCode)
	BEGIN

		IF opCode(5) = '0' THEN
			memReg <= '0';
			writeBack <= '1';
			execSig <= opCode;
		END IF;

	END PROCESS;
END archControlUnit;
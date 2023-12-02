LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY memory IS
	PORT (
		address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memRead : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END memory;

ARCHITECTURE archMemory OF memory IS
	TYPE mem_loc IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL data_mem : mem_loc;
	SIGNAL address_temp, one : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
	PROCESS (address, writeData, memRead, memWrite, address_temp)
	BEGIN
		address_temp <= STD_LOGIC_VECTOR(unsigned(address) + 1);
		IF memWrite = '1' THEN
			data_mem(to_integer(unsigned((address(11 DOWNTO 0))))) <= writeData(31 DOWNTO 16);
			data_mem(to_integer(unsigned((address_temp(11 DOWNTO 0))))) <= writeData(15 DOWNTO 0);
		ELSE
			IF memRead = '1' THEN
				readData <= data_mem(to_integer(unsigned((address(11 DOWNTO 0))))) & data_mem(to_integer(unsigned((address_temp(11 DOWNTO 0)))));
			END IF;
		END IF;
	END PROCESS;
END archMemory;
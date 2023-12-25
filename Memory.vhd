LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY memory IS
	PORT (
		load : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memRead : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		memProtect : IN STD_LOGIC;
		memFree : IN STD_LOGIC;
		readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

	);
END memory;

ARCHITECTURE archMemory OF memory IS
	TYPE mem_loc IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(16 DOWNTO 0);
	SIGNAL data_mem : mem_loc;
	SIGNAL address_temp, one : STD_LOGIC_VECTOR (11 DOWNTO 0);
BEGIN
	PROCESS (address, writeData, memRead, memWrite, address_temp, load, memFree, memProtect)
	BEGIN
		IF load = '0' THEN
			address_temp <= STD_LOGIC_VECTOR(unsigned(address) + 1);
			IF memProtect = '1' THEN
				data_mem(to_integer(unsigned((address))))(0) <= '1';
			ELSE
				IF memFree = '1' THEN
					data_mem(to_integer(unsigned((address)))) <= (OTHERS => '0');
				ELSE
					IF memWrite = '1' AND data_mem(to_integer(unsigned((address))))(0) = '0' AND data_mem(to_integer(unsigned((address_temp))))(0) = '0' THEN
						data_mem(to_integer(unsigned((address))))(16 DOWNTO 1) <= writeData(31 DOWNTO 16);
						data_mem(to_integer(unsigned((address_temp))))(16 DOWNTO 1) <= writeData(15 DOWNTO 0);
					ELSE
						IF memRead = '1' THEN
							readData <= data_mem(to_integer(unsigned((address))))(16 DOWNTO 1) & data_mem(to_integer(unsigned((address_temp))))(16 DOWNTO 1);
						END IF;
					END IF;
				END IF;
			END IF;
		ELSE
			data_mem(0)(16 DOWNTO 1) <= "1000000000000011";
			data_mem(1)(16 DOWNTO 1) <= "1100000000000001";
			data_mem(2)(16 DOWNTO 1) <= "1110000000000010";
			data_mem(3)(16 DOWNTO 1) <= "1111000000000011";
		END IF;
	END PROCESS;
END archMemory;
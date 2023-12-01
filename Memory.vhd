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
SIGNAL address_temp,one : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN


process (address,writeData,memRead,memWrite)
begin
address_temp <= std_logic_vector(unsigned(address)+1);	
	if memWrite = '1' then
		data_mem(to_integer(unsigned((address(11 downto 0)))))<=writeData(31 downto 16);
		data_mem(to_integer(unsigned((address_temp(11 downto 0)))))<=writeData(15 downto 0);
	else
		if memRead = '1' then
			readData <= data_mem(to_integer(unsigned((address(11 downto 0)))))&data_mem(to_integer(unsigned((address_temp(11 downto 0)))));
		end if ;
	end if ;
end process;
	

END archMemory;
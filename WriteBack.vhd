LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY writeBack IS
	PORT (
		resMem : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		swapAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReg : IN STD_LOGIC;
		swap :IN std_logic;
		Swap_Out: OUT std_logic_vector(31 downto 0);
		res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END writeBack;

ARCHITECTURE archWriteBack OF writeBack IS
BEGIN
	res <=
		resMem WHEN memReg = '0' and swap ='0'
		ELSE
		resAlu when memReg = '1' or swap ='1';
	Swap_Out <=swapAlu;

	

END archWriteBack;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dec_exec IS
	PORT (
		readData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- readData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- destRegIn1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- destRegIn2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- opCodeIn : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            -- writeBackIn : IN STD_LOGIC;
            outData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
            -- outData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- opCodeOut : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            -- destRegOut1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- destRegOut2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- writeBackOut : OUT STD_LOGIC
	);
END dec_exec;

ARCHITECTURE arch_dec_exec OF dec_exec IS
BEGIN
	outData1 <= readData1;
	-- outData2 <= readData2;
	-- opCodeOut <= opCodeIn;
	-- destRegOut1 <= destRegIn1;
	-- destRegOut2 <= destRegIn2;
	-- writeBackOut <= writeBackIn;
END arch_dec_exec;
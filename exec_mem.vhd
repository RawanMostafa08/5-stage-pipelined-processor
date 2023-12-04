LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY exec_mem IS
	PORT (
		aluResult_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals_IN :IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		memorySignals_IN :IN STD_LOGIC_VECTOR(6 DOWNTO 0);

		aluResult_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals_OUT :OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		memorySignals_OUT  :OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END exec_mem;

ARCHITECTURE arch_exec_mem OF exec_mem IS
BEGIN
aluResult_OUT <= aluResult_IN; 
destReg0_OUT  <= destReg0_IN ;
destReg1_OUT  <= destReg1_IN ;
fetchSignals_OUT  <= fetchSignals_IN ; 
regFileSignals_OUT <=regFileSignals_IN; 
memorySignals_OUT <=memorySignals_IN ;
END arch_exec_mem;
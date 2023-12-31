LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY mem_writeBack IS
	PORT (
		clk : IN STD_LOGIC;
		resMem_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		swapAlu_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		regFileSignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		ImmEaValue_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

		resMem_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		swapAlu_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		regFileSignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ImmEaValue_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

	);
END mem_writeBack;

ARCHITECTURE arch_mem_writeBack OF mem_writeBack IS
BEGIN
	PROCESS (clk)
	BEGIN
		IF clk = '1' THEN
			resMem_OUT <= resMem_IN;
			resAlu_OUT <= resAlu_IN;
			destReg0_OUT <= destReg0_IN;
			destReg1_OUT <= destReg1_IN;
			regFileSignals_OUT <= regFileSignals_IN;
			memorySignals_OUT <= memorySignals_IN;
			swapAlu_OUT <= swapAlu_IN;
			ImmEaValue_OUT <= ImmEaValue_IN;
		END IF;
	END PROCESS;
END arch_mem_writeBack;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY exec_mem IS
	PORT (
		CCR_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		clk : IN STD_LOGIC;
		Flush : IN STD_LOGIC;
		PC_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ImmEaValue_IN : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		aluResult_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		res_Swap_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		SP_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		aluResult_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals_OUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ImmEaValue_OUT : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		res_Swap_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		SP_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		PC_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		CCR_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END exec_mem;

ARCHITECTURE arch_exec_mem OF exec_mem IS
BEGIN

	PROCESS (clk)
	BEGIN
		IF clk = '1' THEN
			SP_OUT <= SP_IN;
			PC_OUT <= PC_IN;
			aluResult_OUT <= aluResult_IN;
			destReg0_OUT <= destReg0_IN;
			destReg1_OUT <= destReg1_IN;
			ImmEaValue_OUT <= ImmEaValue_IN;
			res_Swap_OUT <= res_Swap_IN;
			IF Flush = '1' THEN
				fetchSignals_OUT <= (OTHERS => '0');
				regFileSignals_OUT <= (OTHERS => '0');
				memorySignals_OUT <= (OTHERS => '0');
			ELSE
				fetchSignals_OUT <= fetchSignals_IN;
				regFileSignals_OUT <= regFileSignals_IN;
				memorySignals_OUT <= memorySignals_IN;
			END IF;
		END IF;
	END PROCESS;
END arch_exec_mem;
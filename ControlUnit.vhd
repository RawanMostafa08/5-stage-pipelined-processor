LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY controlUnit IS
	PORT (
		opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		fetchSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		executeSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		memorySignals : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		isImm : OUT STD_LOGIC
		-- Fetch-->jmp,jx,ret
		-- Regfile-->wb,wb,ren,memReg,swap,flush
		-- Exec-->aluEn,Reg/Imm Op2,flush
		-- Memory-->AddSel1,AddSel2,DataSel,MemR,MemW,memprotect,memfree
		--AddSel1=0 -->when use SP 
		--AddSel=1 --> when use EA

	);
END controlUnit;

ARCHITECTURE archControlUnit OF controlUnit IS
	SIGNAL isImmediate : STD_LOGIC;
BEGIN
	PROCESS (opCode)
	BEGIN
		fetchSignals <= (OTHERS => '0');
		regFileSignals <= (OTHERS => '0');
		executeSignals <= (OTHERS => '0');
		memorySignals <= (OTHERS => '0');
		--register --> memReg=1
		--memory--> memReg=0
		IF isImmediate = '1' THEN
			isImm <='1';
			regFileSignals(0) <= '1'; --Wb
			executeSignals(0) <= '1'; --aluEn
			memorySignals(0) <= '0'; --AddressSel
			memorySignals(1) <= '1'; --AddressSel
			memorySignals(3) <= '1'; --memRead
			regFileSignals(2) <= '0'; --ren
			isImmediate <= '0';
		ELSE 
			isImm <='0';
			CASE opCode IS
				WHEN "000001" =>
					-- NOT
					isImmediate <= '0';
					regFileSignals(3) <= '1'; --memReg
					regFileSignals(0) <= '1'; --wb
					executeSignals(0) <= '1'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN "000100" =>
					-- DEC
					isImmediate <= '0';
					regFileSignals(3) <= '1'; --memReg
					regFileSignals(0) <= '1'; --wb
					executeSignals(0) <= '1'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN "010101" =>
					-- OR
					isImmediate <= '0';
					regFileSignals(3) <= '1'; --memReg
					regFileSignals(0) <= '1'; --wb
					executeSignals(0) <= '1'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN "000101" =>
					-- OUT
					isImmediate <= '0';
					regFileSignals(3) <= '1'; --memReg
					executeSignals(0) <= '1'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN "100101" =>
					-- PROTECT
					isImmediate <= '0';
					memorySignals(0) <= '1'; --AddressSel
					memorySignals(1) <= '0'; --AddressSel
					memorySignals(5) <= '1'; --protect
					executeSignals(0) <= '1'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN "100011" =>
					-- LDD
					isImmediate <= '1';
					regFileSignals(0) <= '0'; --Wb
					executeSignals(0) <= '0'; --aluEn
					regFileSignals(2) <= '1'; --ren

				WHEN OTHERS =>
					-- Default case when opCode does not match any of the specified values
					NULL;
			END CASE;
		END IF;
	END PROCESS;
END archControlUnit;
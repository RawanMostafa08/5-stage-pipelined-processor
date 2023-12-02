LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY controlUnit IS
	PORT (
		opCode : INOUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		fetchSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		executeSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		memorySignals : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		-- Fetch-->jmp,jx,ret
		-- Regfile-->wb,wb,ren,memReg,swap,flush
		-- Exec-->aluEn,Reg/Imm Op2,flush
		-- Memory-->AddSel1,AddSel2,DataSel,MemR,MemW,memRprotect,memWprotect

	);
END controlUnit;

ARCHITECTURE archControlUnit OF controlUnit IS
BEGIN
	PROCESS (opCode)
	BEGIN
		--register --> memReg=1
		--memory--> memReg=0
		IF opCode = "000001" THEN
			regFileSignals(3) <= '0'; --memReg
			regFileSignals(0) <= '1'; --wb
			executeSignals(0) <= '1'; --aluEn
			regFileSignals(2) <= '1'; --ren
			executeSignals(1) <= '0'; --Reg/Imm Op2
		END IF;

	END PROCESS;
END archControlUnit;
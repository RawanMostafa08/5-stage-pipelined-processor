LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY controlUnit IS
	PORT (
		opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
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
	fetchSignals <= (others => '0');
	regFileSignals<= (others => '0');
	executeSignals<= (others => '0');
	memorySignals <= (others => '0');
		--register --> memReg=1
		--memory--> memReg=0
		IF opCode = "000001" THEN
			regFileSignals(3) <= '1'; --memReg
			regFileSignals(0) <= '1'; --wb
			executeSignals(0) <= '1'; --aluEn
			regFileSignals(2) <= '1'; --ren
		else if opCode = "000100" then
			regFileSignals(3) <= '1'; --memReg
			regFileSignals(0) <= '1'; --wb
			executeSignals(0) <= '1'; --aluEn
			regFileSignals(2) <= '1'; --ren
		else if opCode = "010101" then
			regFileSignals(3) <= '1'; --memReg
			regFileSignals(0) <= '1'; --wb
			executeSignals(0) <= '1'; --aluEn
			regFileSignals(2) <= '1'; --ren
		end if ;
		end if;
		END IF;

	END PROCESS;
END archControlUnit;
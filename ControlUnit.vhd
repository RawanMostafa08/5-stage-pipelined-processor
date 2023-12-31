LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY controlUnit IS
	PORT (
		reset          : IN STD_LOGIC;
		opCode         : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		enterProcess   : IN STD_LOGIC;
		fetchSignals   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regFileSignals : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		executeSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		memorySignals  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		isImm          : OUT STD_LOGIC;
		lastOpCode     : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		JZ             : IN STD_LOGIC;
		Jump           : OUT STD_LOGIC;
		Flush_IF_ID    : OUT STD_LOGIC;
		Flush_ID_EX    : OUT STD_LOGIC;
		Flush_EX_MEM   : OUT STD_LOGIC

		-- Fetch-->jmp,jx,ret
		-- Regfile-->wb,wb,ren,memReg,swap,flush,memReg_IN_instruction,isLDM
		-- Exec-->aluEn,Reg/Imm Op2,flush
		-- Memory-->AddSel1,AddSel2,DataSel,MemR,MemW,memprotect,memfree
		--AddSel1=0 -->when use SP 
		--AddSel=1 --> when use EA

	);
END controlUnit;

ARCHITECTURE archControlUnit OF controlUnit IS
	SIGNAL isImmediate    : STD_LOGIC;
	SIGNAL lastOpCode_sig : STD_LOGIC_VECTOR (5 DOWNTO 0);
BEGIN

	PROCESS (enterProcess, JZ)
	BEGIN
		IF reset = '1' THEN
			fetchSignals   <= (OTHERS => '0');
			regFileSignals <= (OTHERS => '0');
			executeSignals <= (OTHERS => '0');
			memorySignals  <= (OTHERS => '0');
			Jump           <= '0';
		ELSE
			-- IF clk = '1' THEN
			fetchSignals   <= (OTHERS => '0');
			regFileSignals <= (OTHERS => '0');
			executeSignals <= (OTHERS => '0');
			memorySignals  <= (OTHERS => '0');
			Jump           <= '0';
			--register --> memReg=1
			--memory--> memReg=0

			IF JZ = '1' THEN
				Flush_IF_ID <= '1';
				Flush_ID_EX <= '1';
			ELSE
				Flush_EX_MEM <= '0';
				Flush_ID_EX  <= '0';
				Flush_IF_ID  <= '0';
				IF isImmediate = '1' THEN
					isImm             <= '1';
					regFileSignals(2) <= '0'; --ren
					isImmediate       <= '0';
					CASE lastOpCode_sig IS
						WHEN "100011" =>
							-- LDD
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							memorySignals(0)  <= '0'; --AddressSel
							memorySignals(1)  <= '1'; --AddressSel
							memorySignals(3)  <= '1'; --memRead
						WHEN "100100" =>
							-- STD
							memorySignals(4) <= '1'; --memWrite
							memorySignals(0) <= '0'; --AddressSel
							memorySignals(1) <= '1'; --AddressSel
							memorySignals(2) <= '1'; --DataSel
							memorySignals(2) <= '1'; --Reg/Imm Op2
						WHEN "100010" =>
							-- LDM
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							memorySignals(2)  <= '1'; --Reg/Imm Op2
							memorySignals(2)  <= '0'; --DataSel
							regFileSignals(6) <= '1'; --isLDM
						WHEN "010010" =>
							-- ADDI
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							executeSignals(1) <= '1'; --Reg/Imm Op2
							regFileSignals(3) <= '1'; --memReg
						WHEN "011000" =>
							-- BITSET
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							executeSignals(1) <= '1'; --Reg/Imm Op2
							regFileSignals(3) <= '1'; --memReg
						WHEN "011001" =>
							-- RCL
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							executeSignals(1) <= '1'; --Reg/Imm Op2
							regFileSignals(3) <= '1'; --memReg
						WHEN "011010" =>
							-- RCR
							regFileSignals(0) <= '1'; --Wb
							executeSignals(0) <= '1'; --aluEn
							executeSignals(1) <= '1'; --Reg/Imm Op2
							regFileSignals(3) <= '1'; --memReg
						WHEN OTHERS               =>
							fetchSignals   <= (OTHERS => '0');
							regFileSignals <= (OTHERS => '0');
							executeSignals <= (OTHERS => '0');
							memorySignals  <= (OTHERS => '0');
					END CASE;
				ELSE
					isImm <= '0';
					CASE opCode IS
						WHEN "000001" =>
							-- NOT
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren

						WHEN "000100" =>
							-- DEC
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010001" =>
							-- ADD
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010011" =>
							-- SUB
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010100" =>
							-- AND
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010101" =>
							-- OR
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010110" =>
							-- XOR
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010111" =>
							-- CMP
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '0'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "000101" =>
							-- OUT
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "000110" =>
							-- IN
							isImmediate       <= '0';
							regFileSignals(0) <= '1'; --Wb
							regFileSignals(5) <= '1'; --memReg_in_instruction
							executeSignals(0) <= '1'; --aluEn
						WHEN "100101" =>
							-- PROTECT
							isImmediate       <= '0';
							memorySignals(0)  <= '1'; --AddressSel
							memorySignals(1)  <= '0'; --AddressSel
							memorySignals(5)  <= '1'; --protect
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren

						WHEN "100110" =>
							-- FREE
							isImmediate       <= '0';
							memorySignals(0)  <= '1'; --AddressSel
							memorySignals(1)  <= '0'; --AddressSel
							memorySignals(6)  <= '1'; --free
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren

						WHEN "100011" =>
							-- LDD 
							isImmediate       <= '1';
							regFileSignals(0) <= '0'; --Wb
							executeSignals(0) <= '0'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "100100" =>
							-- STD 
							isImmediate       <= '1';
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "100010" =>
							-- LDM
							isImmediate       <= '1';
							regFileSignals(2) <= '1'; --ren
						WHEN "010010" =>
							--ADDI
							isImmediate       <= '1';
							regFileSignals(0) <= '0'; --Wb
							executeSignals(0) <= '0'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "011000" =>
							--BITSET
							isImmediate       <= '1';
							regFileSignals(0) <= '0'; --Wb
							executeSignals(0) <= '0'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "011001" =>
							--RCL
							isImmediate       <= '1';
							regFileSignals(0) <= '0'; --Wb
							executeSignals(0) <= '0'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "011010" =>
							--RCR
							isImmediate       <= '1';
							regFileSignals(0) <= '0'; --Wb
							executeSignals(0) <= '0'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "000000" =>
							--NOP
							isImmediate    <= '0';
							fetchSignals   <= (OTHERS => '0');
							regFileSignals <= (OTHERS => '0');
							executeSignals <= (OTHERS => '0');
							memorySignals  <= (OTHERS => '0');
						WHEN "000011"             =>
							--INC
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "000010" =>
							--NEG
							isImmediate       <= '0';
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(0) <= '1'; --wb
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(2) <= '1'; --ren
						WHEN "010000" =>
							--swap
							isImmediate       <= '0';
							regFileSignals(0) <= '1'; --wb
							regFileSignals(1) <= '1'; --wb1
							regFileSignals(2) <= '1'; --ren
							regFileSignals(3) <= '1'; --memReg
							regFileSignals(4) <= '1'; --swap
							executeSignals(0) <= '1'; --aluEn

						WHEN "110000" =>
							--jz
							isImmediate       <= '0';
							regFileSignals(2) <= '1'; --ren
							executeSignals(0) <= '1'; --aluEn

						WHEN "110001" =>
							--jump
							isImmediate       <= '0';
							regFileSignals(2) <= '1'; --ren
							Jump              <= '1';
							Flush_EX_MEM      <= '0';
							Flush_IF_ID       <= '1';
						WHEN "110010" =>
							--call
							isImmediate       <= '0';
							regFileSignals(2) <= '1'; --ren
							memorySignals(4)  <= '1'; --memw
							memorySignals(1)  <= '0'; -- address select (sp)
							memorySignals(0)  <= '0'; -- address select
							memorySignals(2)  <= '0'; -- data select (pc) 
							Jump              <= '1';
							Flush_EX_MEM      <= '0';
							executeSignals(0) <= '1'; --aluEn
							Flush_ID_EX       <= '0';
							Flush_IF_ID       <= '1';

						WHEN "100000" =>
							--PUSH
							isImmediate       <= '0';
							regFileSignals(2) <= '1'; --ren
							executeSignals(0) <= '1'; --aluEn
							memorySignals(0)  <= '0'; --AddressSel
							memorySignals(1)  <= '0'; --AddressSel
							memorySignals(2)  <= '1'; --DataSel
							memorySignals(4)  <= '1'; --MemWrite

						WHEN "100001" =>
							--POP
							isImmediate       <= '0';
							executeSignals(0) <= '1'; --aluEn
							regFileSignals(0) <= '1'; --wb

							memorySignals(0) <= '0'; --AddressSel
							memorySignals(1) <= '0'; --AddressSel

							memorySignals(2) <= '1'; --DataSel
							memorySignals(3) <= '1'; --MemRead
						WHEN "110100" =>
							--RTI 110100
							isImmediate       <= '0';
							fetchSignals(2)   <= '1'; --ret
							executeSignals(0) <= '1'; --aluEn
							memorySignals(3)  <= '1'; --MemRead
							Flush_ID_EX       <= '1';
							Flush_EX_MEM      <= '1';
						WHEN "110011" =>
							--RET 110100
							isImmediate       <= '0';
							fetchSignals(2)   <= '1'; --ret
							executeSignals(0) <= '1'; --aluEn
							memorySignals(3)  <= '1'; --MemRead
							Flush_ID_EX       <= '0';
							Flush_EX_MEM      <= '0';
							Flush_IF_ID       <= '1';
						WHEN OTHERS               =>
							fetchSignals   <= (OTHERS => '0');
							regFileSignals <= (OTHERS => '0');
							executeSignals <= (OTHERS => '0');
							memorySignals  <= (OTHERS => '0');
					END CASE;

				END IF;
			END IF;
			lastOpCode_sig <= opCode;
			lastOpCode     <= lastOpCode_sig;
			-- END IF;
		END IF;
	END PROCESS;
END archControlUnit;
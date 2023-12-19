
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY IF_ID_Reg IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        readReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        writeReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        writeData0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ImmEaValue : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END ENTITY IF_ID_Reg;
ARCHITECTURE IF_ID_RegArch OF IF_ID_Reg IS

BEGIN
    ImmEaValue <= Instruction;
    PROCESS (Instruction)
    BEGIN
        CASE Instruction(15 DOWNTO 14) IS
            WHEN "00" => --one operand
                opCode <= Instruction(15 DOWNTO 10);
                writeReg0 <= Instruction(9 DOWNTO 7);
                readReg0 <= Instruction(6 DOWNTO 4);
            WHEN "01" => --two operands
                opCode <= Instruction(15 DOWNTO 10);
                writeReg0 <= Instruction(9 DOWNTO 7);
                readReg0 <= Instruction(6 DOWNTO 4);
                readReg1 <= Instruction(3 DOWNTO 1);
                writeReg1 <=Instruction(6 DOWNTO 4);
            WHEN "10" => --memory
                opCode <= Instruction(15 DOWNTO 10);
                writeReg0 <= Instruction(9 DOWNTO 7);
                readReg0 <= Instruction(6 DOWNTO 4);
                readReg1 <= Instruction(3 DOWNTO 1);
            WHEN "11" => --branch
                opCode <= Instruction(15 DOWNTO 10);
                writeReg0 <= Instruction(9 DOWNTO 7);
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

END ARCHITECTURE IF_ID_RegArch;
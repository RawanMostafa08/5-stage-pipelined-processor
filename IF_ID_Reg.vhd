
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY IF_ID_Reg IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        PC_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        readReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        writeReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        writeData0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ImmEaValue : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        PC_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

    );
END ENTITY IF_ID_Reg;
ARCHITECTURE IF_ID_RegArch OF IF_ID_Reg IS

BEGIN
    PROCESS (clk, interrupt,reset)
    BEGIN
        IF reset = '1' THEN
            opcode <= "111111";
            writeReg0 <= (OTHERS => 'X');
            readReg0 <= (OTHERS => 'X');
            readReg1 <= (OTHERS => 'X');
        ELSE
            IF interrupt = '1' THEN
                opcode <= "111110";
                writeReg0 <= (OTHERS => 'X');
                readReg0 <= (OTHERS => 'X');
                readReg1 <= (OTHERS => 'X');
            ELSE
                IF clk = '1' THEN
                    ImmEaValue <= Instruction;
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
                            writeReg1 <= Instruction(6 DOWNTO 4);
                        WHEN "10" => --memory
                            opCode <= Instruction(15 DOWNTO 10);
                            writeReg0 <= Instruction(9 DOWNTO 7);
                            readReg0 <= Instruction(6 DOWNTO 4);
                            readReg1 <= Instruction(3 DOWNTO 1);
                        WHEN "11" => --branch
                            opCode <= Instruction(15 DOWNTO 10);
                            writeReg0 <= Instruction(9 DOWNTO 7);
                            readReg0 <= Instruction(6 DOWNTO 4);
                            readReg1 <= Instruction(3 DOWNTO 1);
                        WHEN OTHERS =>
                            opCode <= (OTHERS => 'X');
                            writeReg0 <= (OTHERS => 'X');
                            readReg0 <= (OTHERS => 'X');
                            readReg1 <= (OTHERS => 'X');
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE IF_ID_RegArch;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Integration IS
    PORT (
        clk : IN STD_LOGIC,
        reset : IN STD_LOGIC);
END ENTITY Integration;
ARCHITECTURE IntegrationArch OF Integration IS

    COMPONENT Fetch IS
        PORT (
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IF_ID_Reg IS
        PORT (
            Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            readReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
            -- writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- writeData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

        );
    END COMPONENT;
    COMPONENT regFile IS
        PORT (
            clk : IN STD_LOGIC;
            Reset : IN STD_LOGIC;
            WriteEn0 : IN STD_LOGIC;
            WriteEn1 : IN STD_LOGIC;
            ReadEn0 : IN STD_LOGIC;
            ReadEn1 : IN STD_LOGIC;
            WriteAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            WriteAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            ReadAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            ReadAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            WriteData0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            WriteData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            ReadData0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            ReadData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT dec_exec IS
        PORT (
            readData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- readData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destRegIn1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- destRegIn2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- opCodeIn : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            writeBackIn : IN STD_LOGIC;
            -- outData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- outData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- opCodeOut : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            destRegOut1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
            -- destRegOut2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- writeBackOut : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT execute IS
        PORT (
            op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT writeBack IS
        PORT (
            resMem : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            memReg : IN STD_LOGIC;
            res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
            --regAddress:IN std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            memRead : IN STD_LOGIC;
            memWrite : IN STD_LOGIC;
            readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Instruction_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL readReg1_temp, readReg2_temp, writeReg1_temp, writeReg2_temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL opCode_temp : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL readData0_temp, result, writeData1_temp, writeData2_temp : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL write_back_temp : STD_LOGIC;
    SIGNAL regFile_reset, regFile_WE0, regFile_WE1, regFile_RE0, regFile_RE1 : STD_LOGIC;
    SIGNAL regFile_WriteAdd0, regFile_WriteAdd1, regFile_ReadAdd0, regFile_ReadAdd1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL regFile_ReadData0, regFile_ReadData1, regFile_WriteData0, regFile_WriteData1, readData_Mem : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL memread, memwrite : STD_LOGIC;
BEGIN
    regFile_WE0 <= '1';
    regFile_WE1 <= '1';
    Register_File : regFile PORT MAP(
        clk => clk,
        Reset => regFile_reset,
        WriteEn0 => regFile_WE0,
        WriteEn1 => regFile_WE1,
        ReadEn0 => '1',
        ReadEn1 => '1',
        WriteAdd0 => writeReg1_temp,
        WriteAdd1 => writeReg2_temp,
        ReadAdd0 => readReg1_temp,
        ReadAdd1 => readReg2_temp,
        WriteData0 => regFile_WriteData0,
        WriteData1 => regFile_WriteData1,
        ReadData0 => readData0_temp,
        ReadData1 => regFile_ReadData1
    );
    FetchStage : Fetch PORT MAP(
        Instruction => Instruction_temp

    );
    IF_ID_Register : IF_ID_Reg PORT MAP(
        Instruction => Instruction_temp,
        readReg1 => readReg1_temp,
        readReg2 => readReg2_temp,
        writeReg1 => writeReg1_temp,
        writeReg2 => writeReg2_temp,
        opCode => opCode_temp
    );

    --    ID_EXE_Register: dec_exec port map(
    --        readData1=>readData0_temp,
    --	
    --   );
    ExcuteStage : execute PORT MAP(
        op1 => readData0_temp,
        opCode => opCode_temp,
        res => regFile_WriteData0
    );

    Memory_Stage : memory PORT MAP(
        address => regFile_WriteData0,
        writeData => readData0_temp,
        memRead => memread, --should be changed to get signal from EX/MEM
        memWrite => memwrite, --should be changed to get signal from EX/MEM
        readData => readData_Mem
    );
END ARCHITECTURE IntegrationArch;
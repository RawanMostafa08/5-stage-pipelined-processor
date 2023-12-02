LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Integration IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC);
END ENTITY Integration;
ARCHITECTURE IntegrationArch OF Integration IS

    COMPONENT controlUnit IS
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
    END COMPONENT;
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

    COMPONENT exec_mem IS
        PORT (
            aluResIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destRegIn1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destRegIn2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeBackIn : IN STD_LOGIC;
            destRegOut1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destRegOut2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            aluResOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeBackOut : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT mem_writeBack IS
        PORT (
            resMemIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAluIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeBackIn : IN STD_LOGIC;
            memRegIn : IN STD_LOGIC;
            resMemOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAluOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeBackOut : OUT STD_LOGIC;
            memRegOut : OUT STD_LOGIC
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
    SIGNAL ReadEn0_temp : STD_LOGIC;
    SIGNAL ReadEn1_temp : STD_LOGIC;

    SIGNAL opCode_CU : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL fetchSignals_CU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_CU : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL executeSignals_CU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_CU : STD_LOGIC_VECTOR(6 DOWNTO 0);

    SIGNAL readReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL readReg2_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg2_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    signal opCode_IF_ID: std_logic_vector(5 downto 0);

    SIGNAL readData1_ID_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destRegIn1_ID_EXE : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_ID_EXE : STD_LOGIC;
    SIGNAL destRegOut1_ID_EXE : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL aluResIn_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destRegIn1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destRegIn2_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_EXE_M : STD_LOGIC;
    SIGNAL destRegOut1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destRegOut2_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL aluResOut_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL writeBackOut_EXE_M : STD_LOGIC;

    SIGNAL resMemIn_M_WB : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL resAluIn_M_WB : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL writeBackIn_M_WB : STD_LOGIC;
    SIGNAL memRegIn_M_WB : STD_LOGIC;
    SIGNAL resMemOut_M_WB : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL resAluOut_M_WB : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL writeBackOut_M_WB : STD_LOGIC;
    SIGNAL memRegOut_M_WB : STD_LOGIC;

    SIGNAL instruction_F : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
    regFile_WE0 <= '1';
    regFile_WE1 <= '1';
    CU : ControlUnit PORT MAP(
        opCode => opCode_CU,
        fetchSignals => fetchSignals_CU,
        regFileSignals => regFileSignals_CU,
        executeSignals => executeSignals_CU,
        memorySignals => memorySignals_CU

    );

    FetchStage : Fetch PORT MAP(
        Instruction => Instruction_F

    );
    IF_ID_Register : IF_ID_Reg PORT MAP(
        Instruction => Instruction_F,
        readReg1 => readReg1_IF_ID,
        readReg2 => readReg2_IF_ID,
        writeReg1 => writeReg1_IF_ID,
        writeReg2 => writeReg2_IF_ID,
        opCode => opCode_IF_ID
    );
    Register_File : regFile PORT MAP(
        clk => clk,
        Reset => regFile_reset,
        WriteEn0 => regFile_WE0,
        WriteEn1 => regFile_WE1,
        ReadEn0 => ReadEn0_temp,
        ReadEn1 => ReadEn1_temp,
        WriteAdd0 => writeReg1_temp,
        WriteAdd1 => writeReg2_temp,
        ReadAdd0 => readReg1_temp,
        ReadAdd1 => readReg2_temp,
        WriteData0 => regFile_WriteData0,
        WriteData1 => regFile_WriteData1,
        ReadData0 => readData0_temp,
        ReadData1 => regFile_ReadData1
    );

    ID_EXE_Register : dec_exec PORT MAP(
        readData1 => readData1_ID_EXE,
        destRegIn1 => destRegIn1_ID_EXE,
        writeBackIn => writeBackIn_ID_EXE,
        destRegOut1 => destRegOut1_ID_EXE

    );

    ExcuteStage : execute PORT MAP(
        op1 => readData0_temp,
        opCode => opCode_temp,
        res => regFile_WriteData0
    );

    EXE_M : exec_mem PORT MAP(
        aluResIn => aluResIn_EXE_M,
        destRegIn1 => destRegIn1_EXE_M,
        destRegIn2 => destRegIn2_EXE_M,
        writeBackIn => writeBackIn_EXE_M,
        destRegOut1 => destRegOut1_EXE_M,
        destRegOut2 => destRegOut2_EXE_M,
        aluResOut => aluResOut_EXE_M,
        writeBackOut => writeBackOut_EXE_M
    );
    Memory_Stage : memory PORT MAP(
        address => regFile_WriteData0,
        writeData => readData0_temp,
        memRead => memread, --should be changed to get signal from EX/MEM
        memWrite => memwrite, --should be changed to get signal from EX/MEM
        readData => readData_Mem
    );

    M_WB : mem_writeBack PORT MAP(
        resMemIn => resMemIn_M_WB,
        resAluIn => resAluIn_M_WB,
        writeBackIn => writeBackIn_M_WB,
        memRegIn => memRegIn_M_WB,
        resMemOut => resMemOut_M_WB,
        resAluOut => resAluOut_M_WB,
        writeBackOut => writeBackOut_M_WB,
        memRegOut => memRegOut_M_WB
    );

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            --fetch
            -- fetch_decode--->Decode
            regFile_WE0 <= regFileSignals_CU(0);
            regFile_WE1 <= regFileSignals_CU(1);
            ReadEn0_temp <= regFileSignals_CU(2);
            ReadEn1_temp <= regFileSignals_CU(2);
            readReg1_temp <= readReg1_IF_ID;
            readReg2_temp <= readReg2_IF_ID;
            writeReg1_temp <= writeReg1_IF_ID;
            writeReg2_temp <= writeReg2_IF_ID;
           
            -- decode--->decode_execute
            




            --memory

            --wb

        END IF;
    END PROCESS;

END ARCHITECTURE IntegrationArch;
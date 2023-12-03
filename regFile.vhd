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
    END COMPONENT;
    COMPONENT Fetch IS
        PORT (
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IF_ID_Reg IS
        PORT (
            Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            readReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg0 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            writeData0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

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
            readData0 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode : INOUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            WB0 : INOUT STD_LOGIC;
            WB1 : INOUT STD_LOGIC

        );
    END COMPONENT;
    COMPONENT execute IS
        PORT (
            op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT exec_mem IS
        PORT (
            aluResult : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeBack0 : INOUT STD_LOGIC;
            writeBack1 : INOUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT mem_writeBack IS
        PORT (
            resMem : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeBack0 : INOUT STD_LOGIC;
            writeBack1 : INOUT STD_LOGIC;
            memReg : INOUT STD_LOGIC
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
    SIGNAL readReg0_temp, readReg1_temp, writeReg0_temp, writeReg1_temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL opCode_temp : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL readData0_temp, readData1_temp, writeData1_temp, writeData2_temp : STD_LOGIC_VECTOR (31 DOWNTO 0);
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

    SIGNAL readReg0_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL readReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg0_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL opCode_IF_ID : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL readData0_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL readData1_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destRegIn1_EXE : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_EXE : STD_LOGIC;

    SIGNAL aluRes : STD_LOGIC_VECTOR (31 DOWNTO 0);

    SIGNAL aluResIn_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destRegIn0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destRegIn1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_EXE_M : STD_LOGIC;
    SIGNAL destRegOut0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destRegOut1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL aluResOut_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL writeBackOut_EXE_M : STD_LOGIC;

    SIGNAL address_mem : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL writeData_mem : STD_LOGIC_VECTOR (31 DOWNTO 0);
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
        readReg0 => readReg0_IF_ID,
        readReg1 => readReg1_IF_ID,
        writeReg0 => writeReg0_IF_ID,
        writeReg1 => writeReg1_IF_ID,
        opCode => opCode_IF_ID
    );
    Register_File : regFile PORT MAP(
        clk => clk,
        Reset => regFile_reset,
        WriteEn0 => regFile_WE0,
        WriteEn1 => regFile_WE1,
        ReadEn0 => ReadEn0_temp,
        ReadEn1 => ReadEn1_temp,
        WriteAdd0 => writeReg0_temp,
        WriteAdd1 => writeReg1_temp,
        ReadAdd0 => readReg0_temp,
        ReadAdd1 => readReg1_temp,
        WriteData0 => regFile_WriteData0,
        WriteData1 => regFile_WriteData1,
        ReadData0 => readData0_temp,
        ReadData1 => readData1_temp
    );

    -- ID_EXE_Register : dec_exec PORT MAP(
    --     readData0 => readData0_temp,
    --     readData1 => readData1_temp,
    --     destReg0 => writeReg0_IF_ID,
    --     destReg1 => writeReg1_IF_ID,
    --     WB0 => regFile_WE0,
    --     WB1 => regFile_WE1
    -- );

    -- ExcuteStage : execute PORT MAP(
    --     op1 => readData0_EXE,
    --     op2 => readData1_EXE,
    --     opCode => opCode_temp,
    --     res => aluRes
    -- );

    -- EXE_M : exec_mem PORT MAP(
    --     aluResult => aluRes,
    --     destReg0 => writeReg0_IF_ID,
    --     destReg1 => writeReg1_IF_ID,
    --     writeBack0 => regFile_WE0,
    --     writeBack1 => regFile_WE1
    -- );
    -- Memory_Stage : memory PORT MAP(
    --     address => address_mem,
    --     writeData => writeData_mem,
    --     memRead => memread, --should be changed to get signal from EX/MEM
    --     memWrite => memwrite, --should be changed to get signal from EX/MEM
    --     readData => readData_Mem
    -- );

    -- M_WB : mem_writeBack PORT MAP(
    --     resMem => readData_Mem,
    --     resAlu => aluRes,
    --     destReg0 => writeReg0_IF_ID,
    --     destReg1 => writeReg1_IF_ID,
    --     writeBack0 => regFile_WE0,
    --     writeBack1 => regFile_WE1,
    --     memReg => memRegIn_M_WB
    -- );

    PROCESS (ALL)
    BEGIN
        IF rising_edge(clk) THEN
            --fetch

            -- fetch_decode--->Decode
            REPORT "Debug: Some signal value = ";
            opCode_CU <= "000001";
            regFile_WE0 <= regFileSignals_CU(0);
            regFile_WE1 <= regFileSignals_CU(1);
            ReadEn0_temp <= regFileSignals_CU(2);
            ReadEn1_temp <= regFileSignals_CU(2);
            readReg0_temp <= readReg0_IF_ID;
            readReg1_temp <= readReg1_IF_ID;
            --DECODE_EXECUTE-->EXECUTE
            -- readData0_EXE <= readData0_temp;
            -- readData1_EXE <= readData1_temp;
            -- --execute_memory-->memory
            -- address_mem <= (OTHERS => '0');
            -- writeData_mem <= (OTHERS => '1');
            -- memread <= '0';
            -- memwrite <= '0';
            -- --wb --TEMPORARILY
            -- memRegIn_M_WB <= '1';
            -- regFile_WE0 <= '1';
            -- regFile_WE1 <= '0';
            -- writeReg0_temp <= writeReg0_IF_ID;
        END IF;
    END PROCESS;

END ARCHITECTURE IntegrationArch;
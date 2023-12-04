LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
 USE work.my_pkg.ALL;

ENTITY Integration IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        load : IN STD_LOGIC
    );
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

    COMPONENT InstructionMemory IS
        PORT (
            -- PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- memRead : IN STD_LOGIC;
            load: IN STD_LOGIC;
            Instruction_Memory : OUT memory_array(0 TO 4095)(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Fetch IS
        PORT (
	clk :IN STD_LOGIC;
        Instruction_Memory : IN memory_array(0 TO 4095)(15 DOWNTO 0);
        reset :IN STD_LOGIC;
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
            readData0_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode_IN : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            executeSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);

            readData0_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode_OUT : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            executeSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

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
            aluResult_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);

            aluResult_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT mem_writeBack IS
        PORT (
            resMem_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);

            resMem_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
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

    signal Instruction_Memory_Processor : memory_array(0 TO 4095)(15 DOWNTO 0);

    SIGNAL PC_temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memRead_temp : STD_LOGIC;
    SIGNAL reset_temp : STD_LOGIC;

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
    SIGNAL readData0_ID_EX : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL readData1_ID_EX : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destReg0_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destReg1_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL opCode_ID_EX : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL fetchSignals_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_ID_EX : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL executeSignals_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_ID_EX : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL destReg0_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL readData0_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL readData1_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destRegIn1_EXE : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_EXE : STD_LOGIC;
    SIGNAL opCode_EXE : STD_LOGIC_VECTOR (5 DOWNTO 0);

    SIGNAL aluRes : STD_LOGIC_VECTOR (31 DOWNTO 0);

    -- SIGNAL aluResIn_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- SIGNAL destRegIn0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL destRegIn1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL writeBackIn_EXE_M : STD_LOGIC;
    -- SIGNAL destRegOut0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL destRegOut1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL aluResOut_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- SIGNAL writeBackOut_EXE_M : STD_LOGIC;

    SIGNAL aluResult_EX_MEM : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destReg0_EX_MEM : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destReg1_EX_MEM : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL fetchSignals_EX_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_EX_MEM : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL executeSignals_EX_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_EX_MEM : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL fetchSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL executeSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL destReg0_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
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

    SIGNAL resAlu_MEM_WB_TEMP : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destReg0_MEM_WB_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_MEM_WB_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_MEM_WB_TEMP : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL regFileSignals_MEM_WB_TEMP : STD_LOGIC_VECTOR(4 DOWNTO 0);

    SIGNAL readData_Mem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL resAlu_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destReg0_MEM_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_MEM_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_MEM_WB : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL regFileSignals_MEM_WB : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL instruction_F : STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL resMem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL resAlu_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memReg_WB : STD_LOGIC;
BEGIN
    -- regFile_WE0 <= '1';
    -- regFile_WE1 <= '1';
    CU : ControlUnit PORT MAP(
        opCode => opCode_CU,
        fetchSignals => fetchSignals_CU,
        regFileSignals => regFileSignals_CU,
        executeSignals => executeSignals_CU,
        memorySignals => memorySignals_CU

    );
    Read_Instrunction : InstructionMemory PORT MAP(
        -- PC => PC_temp,
        -- memRead => memRead_temp,
        -- Instruction => Instruction_temp,
        load => load,
		Instruction_Memory =>Instruction_Memory_Processor
    );

    FetchStage : Fetch PORT MAP(
	clk=>clk,
        Instruction_Memory =>Instruction_Memory_Processor,
        reset =>reset,
        instruction =>Instruction_F
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
        WriteEn0 => regFileSignals_MEM_WB(0), --FROM MEM WB
        WriteEn1 => regFileSignals_MEM_WB(1), --FROM MEM WB
        ReadEn0 => regFileSignals_CU(2),
        ReadEn1 => regFileSignals_CU(2),
        WriteAdd0 => writeReg0_temp,
        WriteAdd1 => writeReg1_temp,
        ReadAdd0 => readReg0_temp,
        ReadAdd1 => readReg1_temp,
        WriteData0 => regFile_WriteData0,
        WriteData1 => regFile_WriteData1,
        ReadData0 => readData0_temp,
        ReadData1 => readData1_temp
        --WB FROM MEM_WB
    );

    ID_EXE_Register : dec_exec PORT MAP(
        readData0_IN => readData0_temp,
        readData1_IN => readData1_temp,
        destReg0_IN => destReg0_ID_EX_TEMP,
        destReg1_IN => destReg1_ID_EX_TEMP,
        fetchSignals_IN => fetchSignals_CU,
        regFileSignals_IN => regFileSignals_CU,
        executeSignals_IN => executeSignals_CU,
        memorySignals_IN => memorySignals_CU,
        opCode_IN => opCode_CU,

        readData0_OUT => readData0_ID_EX,
        readData1_OUT => readData1_ID_EX,
        destReg0_OUT => destReg0_ID_EX,
        destReg1_OUT => destReg1_ID_EX,
        fetchSignals_OUT => fetchSignals_ID_EX,
        regFileSignals_OUT => regFileSignals_ID_EX,
        executeSignals_OUT => executeSignals_ID_EX,
        memorySignals_OUT => memorySignals_ID_EX,

        opCode_OUT => opCode_ID_EX

        --WB FROM CU
    );

    ExcuteStage : execute PORT MAP(
        op1 => readData0_EXE,
        op2 => readData1_EXE,
        opCode => opCode_EXE,
        res => aluRes
    );

    EXE_M : exec_mem PORT MAP(
        aluResult_IN => aluRes,
        destReg0_IN => destReg0_EX_MEM_TEMP,
        destReg1_IN => destReg1_EX_MEM_TEMP,
        fetchSignals_IN => fetchSignals_EX_MEM_TEMP,
        regFileSignals_IN => regFileSignals_EX_MEM_TEMP,
        memorySignals_IN => memorySignals_EX_MEM_TEMP,

        aluResult_OUT => aluResult_EX_MEM,
        destReg0_OUT => destReg0_EX_MEM,
        destReg1_OUT => destReg1_EX_MEM,
        fetchSignals_OUT => fetchSignals_EX_MEM,
        regFileSignals_OUT => regFileSignals_EX_MEM,
        memorySignals_OUT => memorySignals_EX_MEM
    );

    Memory_Stage : memory PORT MAP(
        address => address_mem,
        writeData => writeData_mem,
        memRead => memread, --should be changed to get signal from EX/MEM
        memWrite => memwrite, --should be changed to get signal from EX/MEM
        readData => readData_Mem
    );

    M_WB : mem_writeBack PORT MAP(
        resMem_IN => readData_Mem,
        resAlu_IN => resAlu_MEM_WB_TEMP,
        destReg0_IN => destReg0_MEM_WB_TEMP,
        destReg1_IN => destReg1_MEM_WB_TEMP,
        regFileSignals_IN => regFileSignals_MEM_WB_TEMP,
        memorySignals_IN => memorySignals_MEM_WB_TEMP,

        resMem_OUT => readData_Mem_WB,
        resAlu_OUT => resAlu_MEM_WB,
        destReg0_OUT => destReg0_MEM_WB,
        destReg1_OUT => destReg1_MEM_WB,
        regFileSignals_OUT => regFileSignals_MEM_WB,
        memorySignals_OUT => memorySignals_MEM_WB
    );

    WB : writeBack PORT MAP(
        resMem => resMem_WB,
        resAlu => resAlu_WB,
        memReg => memReg_WB,
        res => regFile_WriteData0
    );
    

    PROCESS (clk,load)
    BEGIN
    if load='0' then
        
   
    reset_temp <= '1';
    
        IF rising_edge(clk) THEN
            --fetch

            -- fetch_decode--->Decode
            REPORT "Debug: Some signal value = ";
            opCode_CU <= opCode_IF_ID;

            -- regFile_RE0 <= '1';
            -- regFile_RE1 <= regFileSignals_CU(2);
            readReg0_temp <= readReg0_IF_ID;
            readReg1_temp <= readReg1_IF_ID;
            --DECODE_EXECUTE-->EXECUTE

            readData0_EXE <= readData0_ID_EX;
            readData1_EXE <= readData1_ID_EX;
            opCode_EXE <= opCode_ID_EX;

            fetchSignals_EX_MEM_TEMP <= fetchSignals_ID_EX;
            regFileSignals_EX_MEM_TEMP <= regFileSignals_ID_EX;
            memorySignals_EX_MEM_TEMP <= memorySignals_ID_EX;

            destReg0_ID_EX_TEMP <= writeReg0_IF_ID;
            destReg1_ID_EX_TEMP <= writeReg1_IF_ID;

            destReg0_EX_MEM_TEMP <= destReg0_ID_EX;
            destReg1_EX_MEM_TEMP <= destReg1_ID_EX;
            --execute_memory-->memory
            memread <= memorySignals_EX_MEM(3);
            memwrite <= memorySignals_EX_MEM(4);
            --WB
            resAlu_MEM_WB_TEMP <= aluResult_EX_MEM;
            destReg0_MEM_WB_TEMP <= destReg0_EX_MEM;
            destReg1_MEM_WB_TEMP <= destReg1_EX_MEM;
            memorySignals_MEM_WB_TEMP <= memorySignals_EX_MEM;
            regFileSignals_MEM_WB_TEMP <= regFileSignals_EX_MEM;
            memReg_WB <= regFileSignals_MEM_WB(3);
            writeReg0_temp <= destReg0_MEM_WB;
            resMem_WB <= readData_Mem_WB;
            resAlu_WB <= resAlu_MEM_WB;
            -- address_mem <= (OTHERS => '0');
            -- writeData_mem <= (OTHERS => '1');

            -- --wb --TEMPORARILY
            -- memRegIn_M_WB <= '1';
            -- regFile_WE0 <= '1';
            -- regFile_WE1 <= '0';

            -- regFile_WE0 <= regFileSignals_CU(0);
            -- regFile_WE1 <= regFileSignals_CU(1);

            -- writeReg0_temp <= writeReg0_IF_ID;
        END IF;
       
        else
memRead_temp <='1';
 end if;
            
    END PROCESS;

END ARCHITECTURE IntegrationArch;
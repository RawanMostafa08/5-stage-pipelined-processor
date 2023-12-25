LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pkg.ALL;

ENTITY Integration IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        load : IN STD_LOGIC;
        inPort : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        outPort : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END ENTITY Integration;
ARCHITECTURE IntegrationArch OF Integration IS

    COMPONENT controlUnit IS
        PORT (
            opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            enterProcess : IN STD_LOGIC;
            fetchSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            executeSignals : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memorySignals : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            isImm : OUT STD_LOGIC;
            lastOpCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            Jump : IN STD_LOGIC;
            Flush : OUT STD_LOGIC

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
            load : IN STD_LOGIC;
            Instruction_Memory : OUT memory_array(0 TO 4095)(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Fetch IS
        PORT (
            clk : IN STD_LOGIC;
            Instruction_Memory : IN memory_array(0 TO 4095)(15 DOWNTO 0);
            reset : IN STD_LOGIC;
            Jump : IN STD_LOGIC;
            Jump_PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
            writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            ImmEaValue : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)

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
    COMPONENT AluOperandsSel IS
        PORT (
            readData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);--op2
            readData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            immData : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            lastOpCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            AlutoAluop1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            AlutoAluop2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            MemtoAluop1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            MemtoAluop2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            Sel : IN STD_LOGIC;
            forwardingsignalop1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --alu-mem
            forwardingsignalop2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --alu-mem
            op1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            op2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            opcodeAlu : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT dec_exec IS
        PORT (
            clk : IN STD_LOGIC;
            IsImm : IN STD_LOGIC;
            Flush : IN STD_LOGIC;
            ImmEaValue_IN : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            readData0_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            srcReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            srcReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode_IN : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            executeSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            lastOpCode_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);

            readData0_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            srcReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            srcReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode_OUT : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            executeSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            ImmEaValue_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            lastOpCode_OUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT execute IS
        PORT (
            op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            aluEn : IN STD_LOGIC;
            opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            Jump : OUT STD_LOGIC;
            res_Swap : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            outPort_EXE : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT exec_mem IS
        PORT (
            clk : IN STD_LOGIC;
            Flush : IN STD_LOGIC;
            ImmEaValue_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            aluResult_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            fetchSignals_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            res_Swap_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            aluResult_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            fetchSignals_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            ImmEaValue_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            res_Swap_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT mem_writeBack IS
        PORT (
            resMem_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            swapAlu_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_IN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            regFileSignals_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            memorySignals_IN : IN STD_LOGIC_VECTOR(6 DOWNTO 0);

            resMem_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            swapAlu_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1_OUT : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            regFileSignals_OUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            memorySignals_OUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT writeBack IS
        PORT (
            resMem : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            resAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            swapAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            memReg : IN STD_LOGIC;
            memReg_in_instr : IN STD_LOGIC;
            inPort : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            swap : IN STD_LOGIC;
            Swap_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
            --regAddress:IN std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    COMPONENT AddressSel IS
        PORT (
            aluResult : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            EffectiveAddress : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            Address : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            load : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
            writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            memRead : IN STD_LOGIC;
            memWrite : IN STD_LOGIC;
            memProtect : IN STD_LOGIC;
            memFree : IN STD_LOGIC;
            readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ForwardingUnit IS
        PORT (
            Rsrc1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rsrc2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            RegExecuteMem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            RegMemWb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            forwardingsignalsop1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --alu mem
            forwardingsignalsop2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --alu mem
        );
    END COMPONENT;

    SIGNAL Instruction_Memory_Processor : memory_array(0 TO 4095)(15 DOWNTO 0);
    SIGNAL PC_temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reset_temp : STD_LOGIC;
    SIGNAL EP : STD_LOGIC := '0';
    SIGNAL Instruction_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL readReg0_temp, readReg1_temp, writeReg0_temp, writeReg1_temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL opCode_temp : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL readData0_temp, readData1_temp, writeData1_temp, writeData2_temp : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL ImmEaValue_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL write_back_temp : STD_LOGIC;
    SIGNAL regFile_reset, regFile_WE0, regFile_WE1, regFile_RE0, regFile_RE1 : STD_LOGIC;
    SIGNAL regFile_WriteAdd0, regFile_WriteAdd1, regFile_ReadAdd0, regFile_ReadAdd1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL regFile_ReadData0, regFile_ReadData1, regFile_WriteData0, regFile_WriteData1, readData_Mem : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL memread, memwrite : STD_LOGIC;
    SIGNAL ReadEn0_temp : STD_LOGIC;
    SIGNAL ReadEn1_temp : STD_LOGIC;
    SIGNAL IsImmediate : STD_LOGIC;
    SIGNAL opCode_CU : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL fetchSignals_CU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_CU : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL executeSignals_CU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL lastOpCode_CU : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL memorySignals_CU : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL jumpSig : STD_LOGIC;
    SIGNAL readReg0_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL readReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg0_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeReg1_IF_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL ImmEaValue_IF_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL opCode_IF_ID : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL readData0_ID_EX : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL readData1_ID_EX : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destReg0_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destReg1_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL srcReg0_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL srcReg1_ID_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL opCode_ID_EX : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL fetchSignals_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_ID_EX : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL executeSignals_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ImmEaValue_ID_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL memorySignals_ID_EX : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL lastOpCode_ID_EX : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL destReg0_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL srcReg0_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL srcReg1_ID_EX_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL readData0_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL readData1_EXE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destRegIn1_EXE : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL writeBackIn_EXE : STD_LOGIC;
    SIGNAL opCode_EXE : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL aluEnable : STD_LOGIC;
    SIGNAL operand2Select : STD_LOGIC;
    SIGNAL selectedOp1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL selectedOp2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL selectedOpCode : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL aluRes : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL res_Swap_temp : STD_LOGIC_VECTOR (31 DOWNTO 0);

    -- SIGNAL aluResIn_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- SIGNAL destRegIn0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL destRegIn1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL writeBackIn_EXE_M : STD_LOGIC;
    -- SIGNAL destRegOut0_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL destRegOut1_EXE_M : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- SIGNAL aluResOut_EXE_M : STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- SIGNAL writeBackOut_EXE_M : STD_LOGIC;

    SIGNAL aluResult_EX_MEM : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL swapResult_EX_MEM : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL destReg0_EX_MEM : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL destReg1_EX_MEM : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL fetchSignals_EX_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_EX_MEM : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL executeSignals_EX_MEM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_EX_MEM : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL fetchSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL regFileSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL executeSignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_EX_MEM_TEMP : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL destReg0_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_EX_MEM_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ImmEaValue_EX_MEM_TEMP : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ImmEaValue_EX_MEM : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL address_mem : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL memProtect_temp : STD_LOGIC;
    SIGNAL memFree_temp : STD_LOGIC;
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
    SIGNAL Swap_MEM_WB_TEMP : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destReg0_MEM_WB_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_MEM_WB_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_MEM_WB_TEMP : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL regFileSignals_MEM_WB_TEMP : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL readData_Mem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL resAlu_MEM_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL destReg0_MEM_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destReg1_MEM_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memorySignals_MEM_WB : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL regFileSignals_MEM_WB : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL instruction_F : STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL WriteEn0_temp : STD_LOGIC;
    SIGNAL WriteEn1_temp : STD_LOGIC;

    SIGNAL resMem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL resAlu_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL swapAlu_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memReg_WB : STD_LOGIC;
    SIGNAL memReg_IN_instr_WB : STD_LOGIC;
    SIGNAL inPortSignal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL swap_WB : STD_LOGIC;

    SIGNAL address_result : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL forwardingsignal1_FU : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL forwardingsignal2_FU : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL op1_FU : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL op2_FU : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL RegExecuteMem_FU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL RegMemWb_FU : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL srcReg0_FU : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL srcReg1_FU : STD_LOGIC_VECTOR (2 DOWNTO 0);

    SIGNAL readData1_opSel : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL readData0_opSel : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL aluResult_opSel : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL readData_opSel : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL ImmEaValue_opSel : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL opCode_opSel : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL lastOpCode_opSel : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL executeSignals_opSel : STD_LOGIC;
    SIGNAL flushSig : STD_LOGIC;
BEGIN

    CU : ControlUnit PORT MAP(
        opCode => opCode_CU,
        enterProcess => EP,
        fetchSignals => fetchSignals_CU,
        regFileSignals => regFileSignals_CU,
        executeSignals => executeSignals_CU,
        memorySignals => memorySignals_CU,
        isImm => IsImmediate,
        lastOpCode => lastOpCode_CU,
        Jump => jumpSig,
        Flush => flushSig

    );
    Read_Instrunction : InstructionMemory PORT MAP(
        -- PC => PC_temp,
        -- memRead => memRead_temp,
        -- Instruction => Instruction_temp,
        load => load,
        Instruction_Memory => Instruction_Memory_Processor
    );

    FetchStage : Fetch PORT MAP(
        clk => clk,
        Instruction_Memory => Instruction_Memory_Processor,
        reset => reset,
        Jump => jumpSig,
        Jump_PC => readData0_opSel,
        instruction => Instruction_F
    );
    IF_ID_Register : IF_ID_Reg PORT MAP(
        Instruction => Instruction_F,
        readReg0 => readReg0_IF_ID,
        readReg1 => readReg1_IF_ID,
        writeReg0 => writeReg0_IF_ID,
        writeReg1 => writeReg1_IF_ID,
        opCode => opCode_IF_ID,
        ImmEaValue => ImmEaValue_IF_ID

    );
    Register_File : regFile PORT MAP(
        clk => clk,
        Reset => regFile_reset,
        WriteEn0 => WriteEn0_temp, --FROM MEM WB
        WriteEn1 => WriteEn1_temp, --FROM MEM WB
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
        Flush => flushSig,
        clk => clk,
        isImm => IsImmediate,
        ImmEaValue_IN => ImmEaValue_temp,
        readData0_IN => readData0_temp,
        readData1_IN => readData1_temp,
        destReg0_IN => destReg0_ID_EX_TEMP,
        destReg1_IN => destReg1_ID_EX_TEMP,
        srcReg0_IN => srcReg0_ID_EX_TEMP,
        srcReg1_IN => srcReg1_ID_EX_TEMP,
        fetchSignals_IN => fetchSignals_CU,
        regFileSignals_IN => regFileSignals_CU,
        executeSignals_IN => executeSignals_CU,
        lastOpCode_IN => lastOpCode_CU,
        memorySignals_IN => memorySignals_CU,
        opCode_IN => opCode_CU,

        readData0_OUT => readData0_ID_EX,
        readData1_OUT => readData1_ID_EX,
        destReg0_OUT => destReg0_ID_EX,
        destReg1_OUT => destReg1_ID_EX,
        srcReg0_OUT => srcReg0_ID_EX,
        srcReg1_OUT => srcReg1_ID_EX,
        fetchSignals_OUT => fetchSignals_ID_EX,
        regFileSignals_OUT => regFileSignals_ID_EX,
        executeSignals_OUT => executeSignals_ID_EX,
        memorySignals_OUT => memorySignals_ID_EX,
        lastOpCode_OUT => lastOpCode_ID_EX,

        opCode_OUT => opCode_ID_EX,
        ImmEaValue_OUT => ImmEaValue_ID_EX
        --WB FROM CU
    );
    FU : ForwardingUnit PORT MAP(
        Rsrc1 => srcReg0_FU,
        Rsrc2 => srcReg1_FU,
        RegExecuteMem => RegExecuteMem_FU,
        RegMemWb => RegMemWb_FU,
        forwardingsignalsop1 => op1_FU,
        forwardingsignalsop2 => op2_FU
    );
    OperandSel : AluOperandsSel PORT MAP(
        readData2 => readData1_opSel,
        readData1 => readData0_opSel,
        immData => ImmEaValue_opSel,
        opCode => opCode_opSel,
        lastOpCode => lastOpCode_opSel,
        Sel => executeSignals_opSel,
        forwardingsignalop1 => op1_FU,
        forwardingsignalop2 => op2_FU,
        AlutoAluop1 => aluResult_opSel,
        AlutoAluop2 => aluResult_opSel,
        MemtoAluop1 => regFile_WriteData0,
        MemtoAluop2 => regFile_WriteData0,
        op1 => readData0_EXE,
        op2 => readData1_EXE,
        opcodeAlu => opCode_EXE

    );

    ExcuteStage : execute PORT MAP(
        op1 => readData0_EXE,
        op2 => readData1_EXE,
        aluEn => aluEnable,
        opCode => opCode_EXE,
        res => aluRes,
        Jump => jumpSig,
        res_Swap => res_Swap_temp,
        outPort_EXE => outPort
    );

    EXE_M : exec_mem PORT MAP(
        clk => clk,
        Flush => flushSig,
        ImmEaValue_IN => ImmEaValue_EX_MEM_TEMP,
        aluResult_IN => aluRes,
        destReg0_IN => destReg0_EX_MEM_TEMP,
        destReg1_IN => destReg1_EX_MEM_TEMP,
        fetchSignals_IN => fetchSignals_EX_MEM_TEMP,
        regFileSignals_IN => regFileSignals_EX_MEM_TEMP,
        memorySignals_IN => memorySignals_EX_MEM_TEMP,
        res_Swap_IN => res_Swap_temp,

        aluResult_OUT => aluResult_EX_MEM,
        destReg0_OUT => destReg0_EX_MEM,
        destReg1_OUT => destReg1_EX_MEM,
        fetchSignals_OUT => fetchSignals_EX_MEM,
        regFileSignals_OUT => regFileSignals_EX_MEM,
        memorySignals_OUT => memorySignals_EX_MEM,
        ImmEaValue_OUT => ImmEaValue_EX_MEM,
        res_Swap_OUT => swapResult_EX_MEM

    );

    AddressSelect_Stage : AddressSel PORT MAP(
        aluResult => aluResult_EX_MEM,
        EffectiveAddress => ImmEaValue_EX_MEM,
        Sel => memorySignals_EX_MEM(1) & memorySignals_EX_MEM(0),
        Address => address_result
    );
    Memory_Stage : memory PORT MAP(
        load => load,
        address => address_mem,
        writeData => writeData_mem,
        memRead => memread, --should be changed to get signal from EX/MEM
        memWrite => memwrite, --should be changed to get signal from EX/MEM
        readData => readData_Mem,
        memProtect => memProtect_temp,
        memFree => memFree_temp
    );

    M_WB : mem_writeBack PORT MAP(
        resMem_IN => readData_Mem,
        resAlu_IN => resAlu_MEM_WB_TEMP,
        destReg0_IN => destReg0_MEM_WB_TEMP,
        destReg1_IN => destReg1_MEM_WB_TEMP,
        regFileSignals_IN => regFileSignals_MEM_WB_TEMP,
        memorySignals_IN => memorySignals_MEM_WB_TEMP,
        swapAlu_IN => swapResult_EX_MEM,

        resMem_OUT => readData_Mem_WB,
        resAlu_OUT => resAlu_MEM_WB,
        destReg0_OUT => destReg0_MEM_WB,
        destReg1_OUT => destReg1_MEM_WB,
        regFileSignals_OUT => regFileSignals_MEM_WB,
        memorySignals_OUT => memorySignals_MEM_WB,
        swapAlu_OUT => Swap_MEM_WB_TEMP
    );

    WB : writeBack PORT MAP(
        resMem => resMem_WB,
        resAlu => resAlu_WB,
        swapAlu => swapAlu_WB,
        memReg => memReg_WB,
        memReg_in_instr => memReg_IN_instr_WB,
        inPort => inPortSignal,
        swap => swap_WB,
        Swap_Out => regFile_WriteData1,
        res => regFile_WriteData0
    );

    PROCESS (clk, load)
    BEGIN
        IF load = '0' THEN
            reset_temp <= '1';

            IF rising_edge(clk) THEN
                --fetch

                -- fetch_decode--->Decode
                opCode_CU <= opCode_IF_ID;

                -- regFile_RE0 <= '1';
                -- regFile_RE1 <= regFileSignals_CU(2);
                readReg0_temp <= readReg0_IF_ID;
                readReg1_temp <= readReg1_IF_ID;
                ImmEaValue_temp <= ImmEaValue_IF_ID;
                --DECODE_EXECUTE-->EXECUTE

                -- readData0_EXE <= readData0_ID_EX;
                -- readData0_EXE <= selectedOp1;
                -- readData1_EXE <= selectedOp2;
                -- forwardingsignal1_FU <= op1_FU;
                -- forwardingsignal2_FU <= op2_FU;
                readData1_opSel <= readData1_ID_EX;
                readData0_opSel <= readData0_ID_EX;
                opCode_opSel <= opCode_ID_EX;
                aluResult_opSel <= aluResult_EX_MEM;
                -- readData_opSel<=resAlu_MEM_WB;
                lastOpCode_opSel <= lastOpCode_ID_EX;
                RegExecuteMem_FU <= destReg0_EX_MEM;
                RegMemWb_FU <= destReg0_MEM_WB;

                srcReg0_FU <= srcReg0_ID_EX;
                srcReg1_FU <= srcReg1_ID_EX;
                executeSignals_opSel <= executeSignals_ID_EX(1);
                -- opCode_EXE <= selectedOpCode;

                aluEnable <= executeSignals_ID_EX(0);
                fetchSignals_EX_MEM_TEMP <= fetchSignals_ID_EX;
                regFileSignals_EX_MEM_TEMP <= regFileSignals_ID_EX;
                memorySignals_EX_MEM_TEMP <= memorySignals_ID_EX;

                destReg0_ID_EX_TEMP <= writeReg0_IF_ID;
                destReg1_ID_EX_TEMP <= writeReg1_IF_ID;

                srcReg0_ID_EX_TEMP <= readReg0_IF_ID;
                srcReg1_ID_EX_TEMP <= readReg1_IF_ID;

                destReg0_EX_MEM_TEMP <= destReg0_ID_EX;
                destReg1_EX_MEM_TEMP <= destReg1_ID_EX;
                ImmEaValue_EX_MEM_TEMP <= ImmEaValue_ID_EX;

                --execute_memory-->memory
                memread <= memorySignals_EX_MEM(3);
                memwrite <= memorySignals_EX_MEM(4);
                memProtect_temp <= memorySignals_EX_MEM(5);
                memFree_temp <= memorySignals_EX_MEM(6);
                address_mem <= address_result;
                --WB
                resAlu_MEM_WB_TEMP <= aluResult_EX_MEM;
                destReg0_MEM_WB_TEMP <= destReg0_EX_MEM;
                destReg1_MEM_WB_TEMP <= destReg1_EX_MEM;
                memorySignals_MEM_WB_TEMP <= memorySignals_EX_MEM;
                regFileSignals_MEM_WB_TEMP <= regFileSignals_EX_MEM;
                memReg_WB <= regFileSignals_MEM_WB(3);
                -- memReg_WB <= regFileSignals_MEM_WB(3);
                swap_WB <= regFileSignals_MEM_WB(4);
                writeReg0_temp <= destReg0_MEM_WB;
                writeReg1_temp <= destReg1_MEM_WB;
                resMem_WB <= readData_Mem_WB;
                resAlu_WB <= resAlu_MEM_WB;
                swapAlu_WB <= Swap_MEM_WB_TEMP;
                WriteEn0_temp <= regFileSignals_MEM_WB(0);
                WriteEn1_temp <= regFileSignals_MEM_WB(1);
                EP <= NOT EP;
                inPortSignal <= inPort;
                memReg_IN_instr_WB <= regFileSignals_MEM_WB(5);
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

        ELSE

        END IF;

    END PROCESS;

END ARCHITECTURE IntegrationArch;
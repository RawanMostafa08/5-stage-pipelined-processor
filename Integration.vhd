library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Integration is
    PORT(clk:IN STD_LOGIC);
end entity Integration;
architecture IntegrationArch of Integration is
component regFile IS
	PORT (
		clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		WriteEn0 : IN STD_LOGIC;
		WriteEn1: IN STD_LOGIC;
		ReadEn0 : IN STD_LOGIC;
		ReadEn1 : IN STD_LOGIC;
		WriteAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd0: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteData0 :IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		WriteData1 :IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData0 :OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData1 :OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;
    component Fetch is
        port (
            instruction: OUT std_logic_vector(15 downto 0)
        );
    end component;
    component IF_ID_Reg is
        port (
            Instruction :IN std_logic_vector(15 downto 0);
            readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            readReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
            -- writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- writeData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    
        );
    end component;
--    component decode is
--        PORT (
--            readReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--            readReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--            writeData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--            writeData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--            writeReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--            writeReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--            writeBack : IN STD_LOGIC;
--            readData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
--            -- readData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
--        );
--    end component;
    component dec_exec is
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
    end component;
    component execute is
        PORT (
    op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
    end component;

    component writeBack is 
    PORT (
		resMem : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		resAlu : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memReg : IN STD_LOGIC;
		res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        --regAddress:IN std_logic_vector(2 downto 0)
	);
    end component;
component memory IS
	PORT (
		address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memRead : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		readData : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

    signal Instruction_temp:std_logic_vector(15 downto 0);
    signal readReg1_temp,readReg2_temp,writeReg1_temp,writeReg2_temp:std_logic_vector(2 downto 0);
    signal opCode_temp:STD_LOGIC_VECTOR (5 DOWNTO 0);
    signal readData0_temp,result,writeData1_temp,writeData2_temp,x,y,w:STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal write_back_temp,z:std_logic;
    signal reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7 : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal regFile_reset,regFile_WE0,regFile_WE1,regFile_RE0,regFile_RE1 : std_logic;
    signal regFile_WriteAdd0,regFile_WriteAdd1,regFile_ReadAdd0,regFile_ReadAdd1 :  STD_LOGIC_VECTOR (2 DOWNTO 0);
    signal regFile_ReadData0,regFile_ReadData1,regFile_WriteData0,regFile_WriteData1,readData_Mem :  STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal memread,memwrite:STD_LOGIC;
begin
regFile_WE0<='1';
regFile_WE1<='1';
Register_File : regFile port map (
		clk => clk,
		Reset => regFile_reset,
		WriteEn0 => regFile_WE0,
		WriteEn1 => regFile_WE1,
		ReadEn0 => '1',
		ReadEn1 => '1',
		WriteAdd0 =>  writeReg1_temp  ,
		WriteAdd1 =>  writeReg2_temp  ,
		ReadAdd0 =>  readReg1_temp ,
		ReadAdd1 =>  readReg2_temp  ,
		WriteData0 =>  regFile_WriteData0  ,
		WriteData1 =>  regFile_WriteData1 ,
		ReadData0 =>  readData0_temp,
		ReadData1 =>  regFile_ReadData1
); 


    FetchStage: Fetch port map(
        Instruction=>Instruction_temp

    );
    IF_ID_Register: IF_ID_Reg port map (
        Instruction=>Instruction_temp,
        readReg1=>readReg1_temp,
        readReg2=>readReg2_temp,
        writeReg1=>writeReg1_temp,
        writeReg2=>writeReg2_temp,
        opCode=>opCode_temp
    );

--y<=readData1_temp;
--z<='0';
--    DecodeStage: decode port map(
--        readReg1=>readReg1_temp,
--        readReg2=>readReg2_temp,
--        writeData1=>writeData1_temp,
--        writeData2=>writeData2_temp,
--        writeReg1=>writeReg1_temp,
--        writeReg2=>writeReg2_temp,
--        writeBack=>z,
--        readData1=>readData1_temp
--    );
 --display("readData_temp after decode %b",readData1_temp);

--    ID_EXE_Register: dec_exec port map(
--        readData1=>readData0_temp,
--	
--   );
    ExcuteStage:execute port map (
        op1=>readData0_temp,
        opCode=>opCode_temp,
        res=>regFile_WriteData0
    );

    -- WriteBackStage: writeBack port map(
    --     resAlu=>result,
    --     memReg=>'0',
    --     res=>result
    -- );
--
--DecodeStageWriteBack:  decode port map(
--        readReg1=>readReg1_temp,
--        readReg2=>readReg2_temp,
--        writeData1=>result,
--        writeData2=>result,
--        writeReg1=>writeReg1_temp,
--        writeReg2=>writeReg2_temp,
--        writeBack=>'1',
--        readData1=>readData1_temp
--    );
 
Memory_Stage: memory port map (
address   => regFile_WriteData0,
writeData => readData0_temp,
memRead   => memread,  --should be changed to get signal from EX/MEM
memWrite  => memwrite,  --should be changed to get signal from EX/MEM
readData  =>  readData_Mem
);    
end architecture IntegrationArch;
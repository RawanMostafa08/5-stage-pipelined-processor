library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Integration is
    
end entity Integration;
architecture IntegrationArch of Integration is
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
    component decode is
        PORT (
            readReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            readReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- writeData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- writeData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            writeReg1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            writeReg2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- writeBack : IN STD_LOGIC;
            readData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
            -- readData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;
    component dec_exec is
        PORT (
            readData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
            -- readData2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- destRegIn1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- destRegIn2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- opCodeIn : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            -- writeBackIn : IN STD_LOGIC;
            -- outData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- outData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            -- opCodeOut : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            -- destRegOut1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
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
	);
    end component;


    signal Instruction_temp:std_logic_vector(15 downto 0);
    signal readReg1_temp,readReg2_temp,writeReg1_temp,writeReg2_temp:std_logic_vector(2 downto 0);
    signal opCode_temp:STD_LOGIC_VECTOR (5 DOWNTO 0);
    signal readData1_temp,result:STD_LOGIC_VECTOR (31 DOWNTO 0);
begin

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
    DecodeStage: decode port map(
        readReg1=>readReg1_temp,
        readReg2=>readReg2_temp,
        writeReg1=>writeReg1_temp,
        writeReg2=>writeReg2_temp,
        readData1=>readData1_temp
    );

    --ID_EXE_Register: dec_exec port map(
      --  readData1=>readData1_temp,
	

    --);
    ExcuteStage:execute port map (
        op1=>readData1_temp,
        opCode=>opCode_temp,
        res=>result
    );

    
    
end architecture IntegrationArch;
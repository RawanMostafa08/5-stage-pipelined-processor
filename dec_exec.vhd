LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dec_exec IS
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
END dec_exec;

ARCHITECTURE arch_dec_exec OF dec_exec IS
      SIGNAL destReg_temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
      readData0_OUT <= readData0_IN;
      readData1_OUT <= readData1_IN;
      destReg1_OUT <= destReg1_IN;
      opCode_OUT <= opCode_IN;
      srcReg0_OUT <= srcReg0_IN;
      srcReg1_OUT <= srcReg1_IN;
      PROCESS (clk)
      BEGIN
            IF Flush = '1' THEN
                  fetchSignals_OUT <= (OTHERS => '0');
                  regFileSignals_OUT <= (OTHERS => '0');
                  executeSignals_OUT <= (OTHERS => '0');
                  memorySignals_OUT <= (OTHERS => '0');
            ELSE
                  fetchSignals_OUT <= fetchSignals_IN;
                  regFileSignals_OUT <= regFileSignals_IN;
                  executeSignals_OUT <= executeSignals_IN;
                  memorySignals_OUT <= memorySignals_IN;
                  IF isImm = '1' THEN
                        destReg_temp <= destReg_temp;
                  ELSE
                        destReg_temp <= destReg0_IN;
                  END IF;
            END IF;
      END PROCESS;
      destReg0_OUT <= destReg_temp;
      ImmEaValue_OUT <= ImmEaValue_IN;
      lastOpCode_OUT <= lastOpCode_IN;
END arch_dec_exec;
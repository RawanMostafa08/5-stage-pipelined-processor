LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dec_exec IS
      PORT (
            readData0 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            readData1 : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            destReg0 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            destReg1 : INOUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            opCode : INOUT STD_LOGIC_VECTOR (5 DOWNTO 0);
            WB0 : INOUT STD_LOGIC;
            WB1 : INOUT STD_LOGIC

      );
END dec_exec;

ARCHITECTURE arch_dec_exec OF dec_exec IS
BEGIN
      -- outData2 <= readData2;
      -- opCodeOut <= opCodeIn;
      -- destRegOut1 <= destRegIn1;
      -- destRegOut2 <= destRegIn2;
      -- writeBackOut <= writeBackIn;
END arch_dec_exec;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY AluOperandsSel IS
    PORT (
        readData : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        immData : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        lastOpCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        Sel : IN STD_LOGIC;
        op2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        opcodeAlu : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END AluOperandsSel;

ARCHITECTURE archAluOperandsSel OF AluOperandsSel IS
BEGIN
    op2 <= readData WHEN Sel = '0' ELSE
        (immData'RANGE => immData(15)) & immData;
    opcodeAlu <= opCode WHEN Sel = '0' ELSE
        lastOpCode;
END archAluOperandsSel;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ForwardingUnit IS
    PORT (
        isImm                : IN STD_LOGIC;
        Rsrc1                : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rsrc2                : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RegExecuteMem        : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        RegMemWb             : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        forwardingsignalsop1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --alu mem
        forwardingsignalsop2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)  --alu mem
    );
END ForwardingUnit;

ARCHITECTURE archForwardingUnit OF ForwardingUnit IS
BEGIN

    forwardingsignalsop1(0) <= '1' WHEN ((Rsrc1 = RegExecuteMem) AND (isImm = '0'))ELSE --alu to alu
    '0';
    forwardingsignalsop1(1) <= '1' WHEN (Rsrc1 = RegMemWb) ELSE --mem to alu
    '0';
    forwardingsignalsop2(0) <= '1' WHEN ((Rsrc2 = RegExecuteMem) AND (isImm = '0'))ELSE --alu to alu
    '0';
    forwardingsignalsop2(1) <= '1' WHEN (Rsrc2 = RegMemWb) ELSE --mem to alu
    '0';
END archForwardingUnit;
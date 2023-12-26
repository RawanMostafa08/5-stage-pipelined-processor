LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY AddressSel IS
    PORT (
        SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluResult : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        EffectiveAddress : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Address : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
    );
END AddressSel;

ARCHITECTURE archAddressSel OF AddressSel IS
BEGIN
    PROCESS (ALL)
    BEGIN
        IF Sel = "01" THEN
            Address <= aluResult(11 DOWNTO 0);
        ELSE
            IF Sel = "10" THEN
                Address <= EffectiveAddress(11 DOWNTO 0);

            ELSE
                IF Sel = "00" THEN
                    Address <= SP(11 DOWNTO 0);
                END IF;
            END IF;
        END IF;
    END PROCESS;
END archAddressSel;
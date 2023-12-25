LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY AddressSel IS
    PORT (
        SP: IN std_logic_vector(31 downto 0);
        aluResult : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        EffectiveAddress : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Address : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
    );
END AddressSel;

ARCHITECTURE archAddressSel OF AddressSel IS
BEGIN
    PROCESS (all)
    BEGIN
        IF Sel = "01" THEN
            Address <= aluResult(11 DOWNTO 0);
        ELSE
            IF Sel = "10" THEN
                Address <= EffectiveAddress(11 DOWNTO 0);
        else if Sel ="00" then
                Address <= SP(11 downto 0);
            END IF;
            end IF;
        END IF;
    END PROCESS;
END archAddressSel;
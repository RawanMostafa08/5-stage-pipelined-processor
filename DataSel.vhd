LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DataSel IS
    PORT (
        clk           : IN STD_LOGIC;
        PC            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CC            : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_Data    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Sel           : IN STD_LOGIC;
        Selected_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY DataSel;

ARCHITECTURE archDataSel OF DataSel IS
BEGIN
    -- PROCESS (clk)
    -- BEGIN
    --     IF Sel = '1' THEN
    --         Selected_Data <= write_Data;
    --     ELSE
    --         IF Sel = '0' THEN
    --             Selected_Data <= PC;

    --         END IF;
    --     END IF;
    -- END PROCESS;
    Selected_Data <= write_Data WHEN Sel = '1' ELSE
        PC;
END archDataSel;
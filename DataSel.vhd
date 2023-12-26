library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataSel is
    port (
        clk :IN std_logic;
        PC : In std_logic_vector(31 downto 0);
        CC :IN std_logic_vector(2 downto 0);
        write_Data : IN std_logic_vector(31 downto 0);
        Sel :IN std_logic;
        Selected_Data :OUT std_logic_vector(31 downto 0)
    );
end entity DataSel;

ARCHITECTURE archDataSel OF DataSel IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF Sel = '1' THEN
            Selected_Data <= write_Data;
        ELSE
            IF Sel = '0' THEN
                Selected_Data <= PC;
    
            end IF;
        END IF;
    END PROCESS;
END archDataSel;
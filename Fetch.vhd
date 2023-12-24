LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.my_pkg.ALL;

-- get instruction from memory and update pc 
ENTITY Fetch IS
    PORT (
        clk                : IN STD_LOGIC;
        Instruction_Memory : IN memory_array(0 TO 4095)(15 DOWNTO 0);
        reset              : IN STD_LOGIC;
        Jump               : IN STD_LOGIC;
        Jump_PC            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Fetch;

ARCHITECTURE FetchArch OF Fetch IS
    SIGNAL PC      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_next : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal Instruction_Memory : memory_array(0 TO 4095)(15 DOWNTO 0);

BEGIN
    PROCESS (reset, clk)
        VARIABLE index : INTEGER := to_integer(unsigned(Jump_PC));
    BEGIN
        index := to_integer(unsigned(Jump_PC));
        IF reset = '1' AND clk = '1' THEN
            PC <= (OTHERS => '0');
        ELSE
            IF clk = '1' THEN
                IF Jump = '1' AND index >= 0 AND index < 4096 THEN
                    -- Check if index is within the valid range
                    REPORT "before pc updated" & to_string(index);
                    REPORT "after pc updated" & to_string(index);
                    instruction <= Instruction_Memory(index);
                    PC          <= (STD_LOGIC_VECTOR(to_unsigned(index + 1, 32)));
                ELSE
                    instruction <= Instruction_Memory(to_integer(unsigned(PC)));
                    -- Increment PC by 1
                    PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
                    REPORT "after pc inc" & to_string(PC);

                END IF;
            END IF;

        END IF;
    END PROCESS; -- identifier

END ARCHITECTURE FetchArch;

-- instruction <= "0000010110000000"; --NOT
-- instruction <="0001000110000000"; --DEC
-- instruction <= "0101010110000010"; --OR
-- instruction <= "0001010000010000"; --OUT
-- instruction <= "1001010000010000"; --PROTECT
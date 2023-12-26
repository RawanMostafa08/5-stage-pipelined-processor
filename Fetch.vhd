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
        JZ                 : IN STD_LOGIC;
        JZ_PC              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Jump               : IN STD_LOGIC;
        Jump_PC            : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC                 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY Fetch;

ARCHITECTURE FetchArch OF Fetch IS

    -- signal Instruction_Memory : memory_array(0 TO 4095)(15 DOWNTO 0);

BEGIN
    PROCESS (reset, clk)
        VARIABLE jump_value : INTEGER;
        VARIABLE jz_value   : INTEGER;
        VARIABLE pc_value   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN

        jump_value := to_integer(unsigned(Jump_PC));
        jz_value   := to_integer(unsigned(JZ_PC));
        IF reset = '1' AND clk = '1' THEN
            -- PC <= (OTHERS       => '0');
            pc_value := (OTHERS    => '0');
            instruction <= (OTHERS => 'X');
        ELSE
            IF clk = '1' THEN
                PC <= pc_value;
                IF JZ = '1' AND jz_value >= 0 AND jz_value < 4096 THEN
                    -- Check if index is within the valid range
                    pc_value := (STD_LOGIC_VECTOR(to_unsigned(jz_value, 32)));
                    instruction <= Instruction_Memory(jz_value);
                    pc_value := STD_LOGIC_VECTOR(unsigned(pc_value) + 1);
                ELSE
                    IF Jump = '1' AND jump_value >= 0 AND jump_value < 4096 THEN
                        pc_value := (STD_LOGIC_VECTOR(to_unsigned(jump_value, 32)));
                        instruction <= Instruction_Memory(jump_value);
                        pc_value := STD_LOGIC_VECTOR(unsigned(pc_value) + 1);
                    ELSE
                        -- PC          <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
                        instruction <= Instruction_Memory(to_integer(unsigned(pc_value)));
                        pc_value := STD_LOGIC_VECTOR(unsigned(pc_value) + 1);
                    END IF;
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
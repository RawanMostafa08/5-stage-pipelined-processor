LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
--get instruction from memory and update pc 
ENTITY Fetch IS
    PORT (
        --PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Fetch;
ARCHITECTURE FetchArch OF Fetch IS
    --     component InstructionMemory is
    --         port (
    --             PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

    --             memRead : IN STD_LOGIC;
    -- Instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    --         );
    --         end component;

BEGIN
    --     Fetch_Data: InstructionMemory port map(
    --         PC=>PC,
    -- memRead=>'1',
    -- Instruction=>Instruction
    --     );

    -- instruction <= "0000010110000000"; --NOT
    -- instruction <="0001000110000000"; --DEC
    instruction <= "0101010110000010"; --OR

END ARCHITECTURE FetchArch;
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;
entity InstructionMemory is
    port (
        --PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		memRead : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		Instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
end entity InstructionMemory;
architecture InstructionMemoryArch of InstructionMemory is
begin
--     TYPE Memory_type IS ARRAY(0 TO 31) of std_logic_vector(15 DOWNTO 0);
--     SIGNAL Memory : Memory_type ;
-- 	signal PC:STD_LOGIC_VECTOR (31 DOWNTO 0);
--     begin
--     PC<=(others=>'0');
--     Memory(to_integer(PC)) <= "0000001100000000";
--     --need to be changed to always block
--     Instruction <=Memory(PC) when memRead="1"
--                 else Instruction;

--     Memory(PC) <=writeData when memWrite="1";
                
    
end architecture InstructionMemoryArch;

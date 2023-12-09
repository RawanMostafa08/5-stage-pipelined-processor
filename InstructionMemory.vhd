 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;
 USE work.my_pkg.ALL;

entity InstructionMemory is
    port (
        -- PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		-- memRead : IN STD_LOGIC;
		-- Instruction : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		load: IN STD_LOGIC;
		Instruction_Memory : OUT memory_array(0 TO 4095)(15 DOWNTO 0)
    );
end entity InstructionMemory;
architecture InstructionMemoryArch of InstructionMemory is
	signal ram_temp : memory_array(0 TO 4095)(15 DOWNTO 0);
	component memory_initialization IS
    PORT (
        ram : OUT memory_array(0 TO 4095)(15 DOWNTO 0)

    );
    end component;

begin
	Load_Intsructions: memory_initialization port map(
	ram=>ram_temp
    );
	  process( load,ram_temp )
	begin
		if load='1' then
			Instruction_Memory <= ram_temp;

			
		
		-- else if load='0' and memRead='1'  then
		-- 	Instruction <=Instruction_Memory(to_integer(unsigned((PC))));
			
		end if;

			
		
			
		
	end process ; -- 
    
end architecture InstructionMemoryArch;



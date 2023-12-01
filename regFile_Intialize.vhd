
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE my_pkg IS
    TYPE regFile_array IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;
USE work.my_pkg.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE std.textio.ALL;

ENTITY regFile_initialization IS
    PORT (
        writeEn: in STD_LOGIC; 
        regfile : OUT regFile_array(0 TO 7)(31 DOWNTO 0);
	writeData: STD_LOGIC_VECTOR (31 DOWNTO 0);
        readEn: in STD_LOGIC 
    );
END ENTITY;
ARCHITECTURE arch_regFile_initialization OF regFile_initialization IS

BEGIN
    -- Loading data from the file into memory during initialization
    read_regFile : PROCESS (falling_edge(clk),readEn)
        FILE reg_file : text OPEN READ_MODE IS "regFile.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        FOR i IN regfile'RANGE LOOP
            IF NOT endfile(reg_file) THEN
                readline(reg_file, file_line);
                read(file_line, temp_data);
                regfile(i) <= temp_data;
            ELSE
                file_close(reg_file);
                WAIT;
            END IF;
        END LOOP;
    END PROCESS;

    -- Writing data to the file when 'writen' is asserted
 write_regFile : PROCESS (rising_edge(clk),writeEn)
        FILE reg_file : TEXT OPEN WRITE_MODE IS "regFile.txt";
        VARIABLE file_line : LINE;
    BEGIN

        FOR i IN regfile'RANGE LOOP
            -- Writing each element to a new line in the file
            WRITE(file_line, regfile(i));
            WRITELN(reg_file, file_line);
        END FOR;

        file_close(reg_file);
    END PROCESS;
END ARCHITECTURE;
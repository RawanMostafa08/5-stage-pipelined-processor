LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY regFile IS
	PORT (
		clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		WriteEn0 : IN STD_LOGIC;
		WriteEn1 : IN STD_LOGIC;
		ReadEn0 : IN STD_LOGIC;
		ReadEn1 : IN STD_LOGIC;
		WriteAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteData0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		WriteData1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END regFile;

ARCHITECTURE archRegFile OF regFile IS

	SIGNAL SEL0, SEL1, SEL2, SEL3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');

BEGIN
	SEL0 <= WriteAdd0 & WriteEn0;
	SEL1 <= WriteAdd1 & WriteEn1;
	SEL2 <= ReadAdd0 & ReadEn0;
	SEL3 <= ReadAdd1 & ReadEn1;

	PROCESS (clk, WriteData0,SEL0,SEL1,SEL2,SEL3, WriteData1, R0, R1, R2, R3, R4, R5, R6, R7)
	BEGIN
	report "regfile";
		IF Reset = '1' THEN
			R0 <= (OTHERS => '0');
			R1 <= (OTHERS => '0');
			R2 <= (OTHERS => '0');
			R3 <= (OTHERS => '0');
			R4 <= (OTHERS => '0');
			R5 <= (OTHERS => '0');
			R6 <= (OTHERS => '0');
			R7 <= (OTHERS => '0');
		ELSE
			IF clk = '1' THEN
				-- write data to writeAdd0
				CASE SEL0 IS
					WHEN "0001" =>
						R0 <= WriteData0;
					WHEN "0011" =>
						R1 <= WriteData0;
					WHEN "0101" =>
						R2 <= WriteData0;
					WHEN "0111" =>
						R3 <= WriteData0;
					WHEN "1001" =>
						R4 <= WriteData0;
					WHEN "1011" =>
						R5 <= WriteData0;
					WHEN "1101" =>
						R6 <= WriteData0;
					WHEN "1111" =>
						R7 <= WriteData0;
					WHEN OTHERS =>

				END CASE;
				---- write data to writeAdd1
				CASE SEL1 IS
					WHEN "0001" =>
						R0 <= WriteData1;
					WHEN "0011" =>
						R1 <= WriteData1;
					WHEN "0101" =>
						R2 <= WriteData1;
					WHEN "0111" =>
						R3 <= WriteData1;
					WHEN "1001" =>
						R4 <= WriteData1;
					WHEN "1011" =>
						R5 <= WriteData1;
					WHEN "1101" =>
						R6 <= WriteData1;
					WHEN "1111" =>
						R7 <= WriteData1;
					WHEN OTHERS =>

				END CASE;
			END IF;

			-- read data from readAdd0 
			IF falling_edge(clk) THEN
				CASE SEL2 IS
					WHEN "0001" =>
						ReadData0 <= R0;
					WHEN "0011" =>
						ReadData0 <= R1;
					WHEN "0101" =>
						ReadData0 <= R2;
					WHEN "0111" =>
						ReadData0 <= R3;
					WHEN "1001" =>
						ReadData0 <= R4;
					WHEN "1011" =>
						ReadData0 <= R5;
					WHEN "1101" =>
						ReadData0 <= R6;
					WHEN "1111" =>
						ReadData0 <= R7;
					WHEN OTHERS =>
				END CASE;
				-- read data from readAdd1
				CASE SEL3 IS
					WHEN "0001" =>
						ReadData1 <= R0;
					WHEN "0011" =>
						ReadData1 <= R1;
					WHEN "0101" =>
						ReadData1 <= R2;
					WHEN "0111" =>
						ReadData1 <= R3;
					WHEN "1001" =>
						ReadData1 <= R4;
					WHEN "1011" =>
						ReadData1 <= R5;
					WHEN "1101" =>
						ReadData1 <= R6;
					WHEN "1111" =>
						ReadData1 <= R7;
					WHEN OTHERS =>

				END CASE;
			END IF;
		END IF;

	END PROCESS;
END archRegFile;
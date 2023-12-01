
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY regFile IS
	PORT (
		clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		WriteEn0 : IN STD_LOGIC;
		WriteEn1: IN STD_LOGIC;
		ReadEn0 : IN STD_LOGIC;
		ReadEn1 : IN STD_LOGIC;
		WriteAdd0 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd0: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		ReadAdd1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WriteData0 :IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		WriteData1 :IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData0 :OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ReadData1 :OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END regFile;

ARCHITECTURE archRegFile OF regFile IS

signal SEL0,SEL1,SEL2,SEL3: STD_LOGIC_VECTOR (3 DOWNTO 0);
signal R0,R1,R2,R3,R4,R5,R6,R7 : STD_LOGIC_VECTOR (31 DOWNTO 0):= (OTHERS => '0') ;

BEGIN
	SEL0 <= WriteAdd0&WriteEn0;	
	SEL1 <= WriteAdd1&WriteEn1;
	SEL2 <= ReadAdd0&ReadEn0;
	SEL3 <= ReadAdd1&ReadEn1;

process (clk ,  WriteData0 , WriteData1,R0,R1,R2,R3,R4,R5,R6,R7)
    begin
if Reset = '1' then 
	R0 <= (OTHERS => '0');
	R1 <= (OTHERS => '0');
	R2 <= (OTHERS => '0');
	R3 <= (OTHERS => '0');
	R4 <= (OTHERS => '0');
	R5 <= (OTHERS => '0');
	R6 <= (OTHERS => '0');
	R7 <= (OTHERS => '0');
else 
	if rising_edge(clk) then
	-- write data to writeAdd0
	case SEL0 is
	when "0001" =>
		R0 <= WriteData0 ;
	when "0011" =>
		R1 <= WriteData0 ;
	when "0101"=>
		R2 <= WriteData0 ;
	when "0111" =>
		R3 <= WriteData0 ;
	when "1001" =>
		R4 <= WriteData0 ;
	when "1011" =>
		R5 <= WriteData0 ;
	when "1101"=>
		R6 <= WriteData0 ;
	when "1111" =>
		R7 <= WriteData0 ;
	when others =>
        
        end case;
 	---- write data to writeAdd1
	case SEL1 is
	when "0001" =>
		R0 <= WriteData1 ;
	when "0011" =>
		R1 <= WriteData1 ;
	when "0101"=>
		R2 <= WriteData1 ;
	when "0111" =>
		R3 <= WriteData1 ;
	when "1001" =>
		R4 <= WriteData1 ;
	when "1011" =>
		R5 <= WriteData1 ;
	when "1101"=>
		R6 <= WriteData1 ;
	when "1111" =>
		R7 <= WriteData1 ;
	when others => 
        
        end case;
end if ;

-- read data from readAdd0 
if falling_edge(clk) then
	case SEL2 is
	when "0001" =>
		ReadData0 <= R0;
	when "0011" =>
		ReadData0 <= R1;
	when "0101"=>
		ReadData0 <= R2;
	when "0111" =>
		ReadData0 <= R3;
	when "1001" =>
		ReadData0 <= R4;
	when "1011" =>
		ReadData0 <= R5;
	when "1101"=>
		ReadData0 <= R6;
	when "1111" =>
		ReadData0 <= R7;
	when others =>
        end case;
 	-- read data from readAdd1
	case SEL3 is
	when "0001" =>
		ReadData1 <= R0;
	when "0011" =>
		ReadData1 <= R1;
	when "0101"=>
		ReadData1 <= R2;
	when "0111" =>
		ReadData1 <= R3;
	when "1001" =>
		ReadData1 <= R4;
	when "1011" =>
		ReadData1 <= R5;
	when "1101"=>
		ReadData1 <= R6;
	when "1111" =>
		ReadData1 <= R7;
	when others =>
        
        end case;
end if;
end if;

end Process;
END archRegFile;
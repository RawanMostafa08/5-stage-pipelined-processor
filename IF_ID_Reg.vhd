
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity IF_ID_Reg is
    port (
        Instruction :IN std_logic_vector(15 downto 0);
        readReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		readReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeReg1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		writeReg2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        opCode : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		writeData1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeData2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

    );
end entity IF_ID_Reg;
architecture IF_ID_RegArch of IF_ID_Reg is
    
begin
    process(Instruction)
    begin
        case Instruction(15 downto 14) is
            when "00" =>
                opCode <= Instruction(15 downto 10);
                writeReg1 <= Instruction(9 downto 7);
                readReg1 <= Instruction(6 downto 4);
            when "01" =>
                opCode <= Instruction(15 downto 10);
                writeReg1 <= Instruction(9 downto 7);
                readReg1 <= Instruction(6 downto 4);
                readReg2 <= Instruction(3 downto 1);
            when "10"=>
                opCode <= Instruction(15 downto 10);
                writeReg1 <= Instruction(9 downto 7);
                readReg1 <= Instruction(6 downto 4);
                readReg2 <= Instruction(3 downto 1);
            when "11" =>
                opCode <= Instruction(15 downto 10);
                writeReg1 <= Instruction(9 downto 7);
		when others =>
        readReg1 <= Instruction(7 downto 5);
        end case;
    end process;
    

    
end architecture IF_ID_RegArch;
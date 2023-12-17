LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY execute IS
  PORT (
    op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    aluEn : IN STD_LOGIC;
    opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    outPort_EXE : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END execute;

ARCHITECTURE archExecute OF execute IS
  SIGNAL CCR : STD_LOGIC_VECTOR(2 DOWNTO 0); --c n z 
  SIGNAL temp_res : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN

  PROCESS (opCode, temp_res, op1, op2)
  BEGIN
    IF aluEn = '1' THEN
      CASE opCode IS
        WHEN "000001" =>
          -- NOT
          temp_res <= NOT op1;
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "000101" =>
          -- OUT
          outPort_EXE <= op1;
        WHEN "000100" =>
          -- DEC
          temp_res <= STD_LOGIC_VECTOR(signed(op1) - 1);
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010001" =>
          -- ADD
          temp_res <= STD_LOGIC_VECTOR(signed(op1) + signed(op2));
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010011" =>
          -- SUB
          temp_res <= STD_LOGIC_VECTOR(signed(op1) - signed(op2));
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010100" =>
          -- AND
          temp_res <= op1 AND op2;
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010110" =>
          -- XOR
          temp_res <= op1 XOR op2;
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010101" =>
          -- OR
          temp_res <= op1 OR op2;
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "100101" =>
          -- PROTECT
          res <= op1;
        WHEN "010010" =>
          -- ADDI
          temp_res <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011000" =>
          -- BITSET
          temp_res <= op1;
          temp_res(to_integer(unsigned(op2))) <= '1';
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011001" =>
          -- RCL
          FOR i IN 1 TO to_integer(unsigned(op2)) LOOP
            temp_res <= CCR(2) & temp_res(30 DOWNTO 0); -- RCL operation
            CCR(2) <= temp_res(31);
          END LOOP;
          -- temp_res <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011010" =>
          -- RCR
          FOR i IN 1 TO to_integer(unsigned(op2)) LOOP
            temp_res <= temp_res(31 DOWNTO 1) & CCR(2); -- RCL operation
            CCR(2) <= temp_res(0);
          END LOOP;
          -- temp_res <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
          res <= temp_res;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN OTHERS =>
          -- Default case when opCode does not match any of the specified values
          NULL;
      END CASE;
    END IF;

  END PROCESS;

END archExecute;
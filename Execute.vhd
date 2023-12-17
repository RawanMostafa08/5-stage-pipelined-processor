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
  SIGNAL CCR : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); --c n z 
  SIGNAL temp_res : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL reswithcarry : STD_LOGIC_VECTOR (32 DOWNTO 0);
BEGIN

  PROCESS (opCode, temp_res, reswithcarry, op1, op2)
    VARIABLE temp_rot : STD_LOGIC_VECTOR (31 DOWNTO 0);
    VARIABLE temp_carry : STD_LOGIC;
    VARIABLE last_bit : STD_LOGIC;
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
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) + ('0' & signed(op2)));
          res <= reswithcarry(31 DOWNTO 0);
          CCR(2) <= reswithcarry(32);
          CCR(1) <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010011" | "010111" =>
          -- SUB or CMP
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) - ('0' & signed(op2)));
          res <= reswithcarry(31 DOWNTO 0);
          CCR(2) <= reswithcarry(32);
          CCR(1) <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
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
        WHEN "100101" =>
          -- PROTECT
          res <= op1;
        WHEN "010010" =>
          -- ADDI
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) + ('0' & signed(op2)));
          res <= reswithcarry(31 DOWNTO 0);
          CCR(2) <= reswithcarry(32);
          CCR(1) <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
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
          temp_rot := op1;
          temp_carry := CCR(2);
          -- REPORT "op1 value: " & to_string(op1);
          -- REPORT "op2 value: " & to_string(op2);
          FOR i IN 1 TO to_integer(unsigned(op2)) LOOP
            last_bit := temp_rot(31);
            -- REPORT "Entering loop iteration " & INTEGER'image(i);
            temp_rot := temp_rot(30 DOWNTO 0) & temp_carry; -- RCL operation
            temp_carry := last_bit;
          END LOOP;
          res <= temp_rot;
          CCR(2) <= temp_carry;
          -- temp_res <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011010" =>
          -- RCR
          temp_res <= op1;
          FOR i IN 1 TO to_integer(unsigned(op2)) LOOP
            temp_res <= CCR(2) & temp_res(31 DOWNTO 1); -- RCL operation
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
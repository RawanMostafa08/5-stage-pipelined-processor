LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY execute IS
  PORT (
    PC_IN       : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    op1         : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    op2         : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    aluEn       : IN STD_LOGIC;
    opCode      : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    res         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    JZ          : OUT STD_LOGIC;
    res_Swap    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    outPort_EXE : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    SP          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    PC_OUT      : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    CCR_OUT     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    inport      : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END execute;

ARCHITECTURE archExecute OF execute IS
  SIGNAL CCR          : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); --c n z 
  SIGNAL temp_res     : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL reswithcarry : STD_LOGIC_VECTOR (32 DOWNTO 0);
  SIGNAL SP_signal    : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111111"; --SP is intially =4095
BEGIN
  CCR_OUT <= CCR;
  PROCESS (opCode, temp_res, reswithcarry, op1, op2)
    VARIABLE temp_rot   : STD_LOGIC_VECTOR (31 DOWNTO 0);
    VARIABLE temp_carry : STD_LOGIC;
    VARIABLE last_bit   : STD_LOGIC;
    VARIABLE SP_var     : INTEGER;
  BEGIN
    REPORT "execute";
    JZ <= '0' WHEN opCode /= "110000";
    IF aluEn = '1' THEN
      CASE opCode IS
        WHEN "000001" =>
          -- NOT
          temp_res <= NOT op1;
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
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
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) - 1);
          CCR(2)       <= reswithcarry(32);
          res          <= reswithcarry(31 DOWNTO 0);
          CCR(1)       <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;

        WHEN "010001" =>
          -- ADD
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) + ('0' & signed(op2)));
          res          <= reswithcarry(31 DOWNTO 0);
          CCR(2)       <= reswithcarry(32);
          CCR(1)       <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010011" | "010111" =>
          -- SUB or CMP
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) - ('0' & signed(op2)));
          res          <= reswithcarry(31 DOWNTO 0);
          CCR(2)       <= reswithcarry(32);
          CCR(1)       <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010100" =>
          -- AND
          temp_res <= op1 AND op2;
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010101" =>
          -- OR
          temp_res <= op1 OR op2;
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010110" =>
          -- XOR
          temp_res <= op1 XOR op2;
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
          IF temp_res = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "100101" =>
          -- PROTECT
          res <= op1;
        WHEN "100110" =>
          -- FREE
          res <= op1;
        WHEN "100100" =>
          -- STD
          res <= op1;
        WHEN "010010" =>
          -- ADDI
          reswithcarry <= STD_LOGIC_VECTOR(('0' & signed(op1)) + ('0' & signed(op2)));
          res          <= reswithcarry(31 DOWNTO 0);
          CCR(2)       <= reswithcarry(32);
          CCR(1)       <= reswithcarry(31);
          IF reswithcarry(31 DOWNTO 0) = X"00000000" THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011000" =>
          -- BITSET
          temp_res                                        <= op1;
          temp_res(to_integer(unsigned(op2(4 DOWNTO 0)))) <= '1';
          res                                             <= temp_res;
          CCR(1)                                          <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011001" =>
          -- RCL
          temp_rot   := op1;
          temp_carry := CCR(2);
          -- REPORT "op1 value: " & to_string(op1);
          -- REPORT "op2 value: " & to_string(op2);
          FOR i IN 1 TO to_integer(unsigned(op2(4 DOWNTO 0))) LOOP
            last_bit := temp_rot(31);
            -- REPORT "Entering loop iteration " & INTEGER'image(i);
            temp_rot   := temp_rot(30 DOWNTO 0) & temp_carry; -- RCL operation
            temp_carry := last_bit;
          END LOOP;
          res    <= temp_rot;
          CCR(2) <= temp_carry;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "011010" =>
          -- RCR
          temp_rot   := op1;
          temp_carry := CCR(2);
          FOR i IN 1 TO to_integer(unsigned(op2(4 DOWNTO 0))) LOOP
            last_bit   := temp_rot(0);
            temp_rot   := temp_carry & temp_rot(31 DOWNTO 1); -- RCL operation
            temp_carry := last_bit;
          END LOOP;
          res    <= temp_rot;
          CCR(2) <= temp_carry;
          CCR(1) <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "000011" =>
          --INC
          temp_res <= STD_LOGIC_VECTOR(signed(op1) + 1);
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
          --in case of adding -1+1
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
          IF op1 = X"FFFFFFFF"THEN
            CCR(2) <= '1';
          ELSE
            CCR(2) <= '0';
          END IF;
        WHEN "000010" =>
          --NEG
          temp_res <= STD_LOGIC_VECTOR(0 - signed(op1));
          res      <= temp_res;
          CCR(1)   <= temp_res(31);
          IF temp_res = X"00000000"THEN
            CCR(0) <= '1';
          ELSE
            CCR(0) <= '0';
          END IF;
        WHEN "010000" =>
          -- swap
          temp_res <= op1;
          res      <= temp_res;
          res_Swap <= op2;
        WHEN "110000" =>
          -- jz
          REPORT "in exceute" & to_string(JZ) & "   " & to_string(temp_res);
          IF CCR(0) = '1'THEN
            JZ     <= '1';
            CCR(0) <= '0';
          END IF;
        WHEN "110010" =>
          -- Call
          SP        <= SP_signal;
          SP_signal <= STD_LOGIC_VECTOR(unsigned(SP_signal) - 1);
          PC_OUT    <= STD_LOGIC_VECTOR(unsigned(PC_IN) + 1);
        WHEN "100000" =>
          --PUSH
          SP        <= SP_signal;
          SP_signal <= STD_LOGIC_VECTOR(unsigned(SP_signal) - 1);
          res       <= op1;
        WHEN "100001" =>
          --POP
          SP_signal <= STD_LOGIC_VECTOR(unsigned(SP_signal) + 1);
          SP        <= SP_signal;
        WHEN "111111" =>
          -- reset
          temp_res <= (OTHERS => '0');
          res      <= temp_res;
        WHEN "110100" =>
          --RTI
          SP_var := to_integer(unsigned(SP_signal)) + 2;

          -- Convert the variable back to std_logic_vector
          SP        <= STD_LOGIC_VECTOR(to_unsigned(SP_var, SP'length));
          SP_signal <= SP;
        WHEN "110011" =>
          --RET
          SP_var := to_integer(unsigned(SP_signal)) + 2;

          -- Convert the variable back to std_logic_vector
          SP        <= STD_LOGIC_VECTOR(to_unsigned(SP_var, SP'length));
          SP_signal <= SP;
        WHEN OTHERS =>
          -- Default case when opCode does not match any of the specified values
          NULL;
      END CASE;
    END IF;

  END PROCESS;

END archExecute;
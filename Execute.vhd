LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY execute IS
  PORT (
    op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    -- op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    opCode : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    res : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END execute;

ARCHITECTURE archExecute OF execute IS
  SIGNAL CCR : STD_LOGIC_VECTOR(2 DOWNTO 0); --c n z 
  SIGNAL temp_res : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN

  PROCESS (opCode, temp_res, op1)
  BEGIN
    IF opCode = "000001" THEN
      temp_res <= NOT op1;
      res <= temp_res;
      CCR(1) <= temp_res(31);
      IF temp_res = X"00000000"THEN
        CCR(0) <= '1';
      ELSE
        CCR(0) <= '0';
      END IF;
    END IF;

  END PROCESS;

END archExecute;
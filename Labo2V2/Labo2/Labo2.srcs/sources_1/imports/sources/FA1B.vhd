----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: firstname lastname and other guy/girl/...
-- 
-- Module Name: FA1B - Behavioral
-- Course Name: Lab Digital Design
--
-- Description:
--  Full adder (1-bit)
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FA1B IS 
	PORT(
		-- TODO: complete entity declaration
		a : in  std_logic; -- input var 1
        b : in  std_logic; -- input var 2
        carry_in : in  std_logic;                                   -- input carry
        result : out std_logic; -- alu operation result
        carry_out : out std_logic                                    -- carry
	);
END entity;

ARCHITECTURE LDD1 OF FA1B IS
BEGIN
	-- TODO: complete architecture
    result <= a xor b xor carry_in;
    carry_out <= (a and b) or ((a xor b) and carry_in);
	
END LDD1;


----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: firstname lastname and other guy/girl/...
-- 
-- Module Name: ADD - Structural
-- Course Name: Lab Digital Design
--
-- Description:
--  n-bit ripple carry adder
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ADD is
	generic(
       C_DATA_WIDTH : natural := 4
	);
	port(
                a : in  std_logic_vector((C_DATA_WIDTH-1) downto 0); -- input var 1
                b : in  std_logic_vector((C_DATA_WIDTH-1) downto 0); -- input var 2
         carry_in : in  std_logic;                                   -- input carry
           result : out std_logic_vector((C_DATA_WIDTH-1) downto 0); -- alu operation result
        carry_out : out std_logic                                    -- carry
	);
end entity;

architecture LDD1 of ADD is
	-- TODO: list of signals and components
    
	-- signals
	signal c : std_logic_vector(C_DATA_WIDTH downto 0);
	
	-- components
	component FA1B 
            PORT(
                -- TODO: complete entity declaration
                a : in  std_logic; -- input var 1
                b : in  std_logic; -- input var 2
                carry_in : in  std_logic;                                   -- input carry
                result : out std_logic; -- alu operation result
                carry_out : out std_logic                                    -- carry
                );
     end component;

begin
	-- TODO: complete architecture description
	c(0) <= carry_in;
	
	for_generate: for i in 0 to C_DATA_WIDTH-1 generate
	begin
	   u1: FA1B
	       port map(
	           a => a(i),
	           b => b(i),
	           carry_in => c(i),
	           result => result(i),
	           carry_out => c(i+1)
	        );
	end generate for_generate;
	   
	carry_out <= c(C_DATA_WIDTH);
	
end LDD1;

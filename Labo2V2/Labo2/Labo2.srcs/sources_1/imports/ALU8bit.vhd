----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Frederik Callens en Jonas De Schoenmacker
-- 
-- Module Name: ALU8bit - Behavioral
-- Course Name: Lab Digital Design
--
-- Description: 
--  8-bit ALU that supports several logic and arithmetic operations
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- TODO: use processor_pkg from the work library
library work;
use work.processor_pkg.ALL;

entity ALU8bit is
    generic(
        C_DATA_WIDTH : natural := 8
    );
    port(
         X : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
         Y : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
         Z : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
        -- operation select
        op : in std_logic_vector(3 downto 0);
        -- flags
        zf : out std_logic;
        cf : out std_logic;
        ef : out std_logic;
        gf : out std_logic;
        sf : out std_logic
    );
end ALU8bit;

architecture Behavioral of ALU8bit is
    -- operations defined in processor_pkg
    -- ALU_OP_NOT  
    -- ALU_OP_AND  
    -- ALU_OP_OR   
    -- ALU_OP_XOR  
    -- ALU_OP_ADD  
    -- ALU_OP_CMP  
    -- ALU_OP_RR   
    -- ALU_OP_RL   
    -- ALU_OP_SWAP 

    -- operation results
    signal result_i      : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal not_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal and_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal or_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal xor_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal rr_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal rl_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal add_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal swap_result_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    -- help signals
    signal add_secondary_input_i     : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal add_carry_in_i: std_logic := '0';
    signal add_carry_i   : std_logic := '0';
    
    signal rr_carry: std_logic := '0';
    signal rl_carry: std_logic := '0';

    signal zeros: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    
    -- we use a separate module for the addition/subtraction
    component ADD is
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
    end component;
begin
    
    -- TODO: complete the following lines to perform logical operations
    -- implementation of some operations
    -- and
    and_result_i <= X and Y;
    -- or
    or_result_i <= X or Y;
    -- xor
    xor_result_i <= X xor Y;
    -- not
    not_result_i <= not(X) ;
    -- rr
    rr_result_i <= '0' & X(C_DATA_WIDTH-1 downto 1);
    rr_carry <= X(0);
    -- rl
    rl_result_i <= X(C_DATA_WIDTH-2 downto 0) & '0';
    rl_carry <= X(C_DATA_WIDTH-1);
    -- swap
    swap_result_i <= X((C_DATA_WIDTH/2)-1 downto 0) & X(C_DATA_WIDTH-1 downto C_DATA_WIDTH/2); 
    
    -- TODO: have a look at how this module is instantiated
    -- Ripple carry adder instantiation
    ADDER : ADD
    generic map(
        C_DATA_WIDTH => C_DATA_WIDTH -- this will change the default width of the adder to the width specified here
    )
    port map(
                a => X,
                b => add_secondary_input_i,
         carry_in => add_carry_in_i,
           result => add_result_i,
        carry_out => add_carry_i
    );

    -- TODO: change the adder's secondary input and carry in, based on the operation (addition/subtraction)
    -- addition and subtraction
    add_secondary_input_i <= Y when (op=ALU_OP_ADD) else not(Y);
    add_carry_in_i <= '0' when (op=ALU_OP_ADD) else '1';
    
    -- TODO: set 'result_i' to a specific operation result based on the selected operation 'op'
    -- result mux:
    with op select
        result_i <= and_result_i when ALU_OP_AND,
                    or_result_i when ALU_OP_OR,
                    xor_result_i when ALU_OP_XOR,
                    not_result_i when ALU_OP_NOT,
                    rr_result_i when ALU_OP_RR,
                    rl_result_i when ALU_OP_RL,
                    add_result_i when ALU_OP_ADD,
                    add_result_i when ALU_OP_SUB,
                    swap_result_i when others;
    
--    result_i <= and_result_i when (op=ALU_OP_AND) else
--                or_result_i when (op=ALU_OP_OR) else
--                xor_result_i when (op=ALU_OP_XOR) else
--                not_result_i when (op=ALU_OP_NOT) else
--                rr_result_i when (op=ALU_OP_RR) else
--                rl_result_i when (op=ALU_OP_RL) else
--                add_result_i when (op=ALU_OP_ADD) else
--                add_result_i when (op=ALU_OP_SUB) else
--                swap_result_i;
    Z <= result_i;
    
--    add_carry_i <= not(add_carry_i) when (op=ALU_OP_SUB) else
--                    add_carry_i;
    -- TODO: control the flags
    -- carry flag: 1 carry flag for SUB, ADD, RR and RL (based on op)
    --   don't forget that rotate left/right can also produce a carry
    --   you might need some extra signals
    cf <= rr_carry when (op=ALU_OP_RR) else
            rl_carry when (op=ALU_OP_RL) else
            add_carry_i when (op=ALU_OP_ADD) else
            not(add_carry_i);
    -- zero flag
    zf <= '1' when result_i = zeros else '0';
    
    -- equal, smaller, greater flag
    ef <= '1' when X=Y else '0';
    gf <= '1' when X>Y else '0';
    sf <= '1' when X<Y else '0';

end Behavioral;

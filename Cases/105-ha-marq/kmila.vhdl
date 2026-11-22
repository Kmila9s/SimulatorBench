library ieee;
use ieee.std_logic_1164.all;

entity Exercici_2 is
    port (
        A     : in  std_logic;
        B     : in  std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end Exercici_2;

architecture rtl of Exercici_2 is
begin
    SUM   <= A xor B;
    CARRY <= A and B;
end rtl;

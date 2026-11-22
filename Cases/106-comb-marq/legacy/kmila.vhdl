library ieee;
use ieee.std_logic_1164.all;

entity Exercici_3 is
    port (
        A : in  std_logic;
        B : in  std_logic;
        C : in  std_logic;
        Q : out std_logic
    );
end Exercici_3;

architecture rtl of Exercici_3 is
begin
    Q <= (A or B) and C;
end rtl;

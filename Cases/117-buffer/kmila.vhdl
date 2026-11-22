library ieee;
use ieee.std_logic_1164.all;

entity Exercici_1 is
    port (
        x : in  std_logic;
        y : out std_logic
    );
end Exercici_1;

architecture rtl of Exercici_1 is
begin
    y <= x;
end rtl;

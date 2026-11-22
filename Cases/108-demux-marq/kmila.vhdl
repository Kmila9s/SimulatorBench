library ieee;
use ieee.std_logic_1164.all;

entity Exercici_5 is
    port (
        D   : in  std_logic;
        sel : in  std_logic_vector(1 downto 0);
        Y   : out std_logic_vector(3 downto 0)
    );
end Exercici_5;

architecture rtl of Exercici_5 is
begin
    Y(0) <= D when sel = "00" else '0';
    Y(1) <= D when sel = "01" else '0';
    Y(2) <= D when sel = "10" else '0';
    Y(3) <= D when sel = "11" else '0';
end rtl;

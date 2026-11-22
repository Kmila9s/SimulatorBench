library ieee;
use ieee.std_logic_1164.all;

entity not_gate is
    port (
        a : in  std_logic_vector(5 downto 0);
        o : out std_logic_vector(5 downto 0)
    );
end not_gate;

architecture rtl of not_gate is
begin
    o <= not a;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mul_width_tripwire is
    port (
        a   : in  std_logic_vector(4 downto 0);
        b   : in  std_logic_vector(4 downto 0);
        out9: out std_logic_vector(8 downto 0)
    );
end mul_width_tripwire;

architecture rtl of mul_width_tripwire is
    signal prod : unsigned(9 downto 0);
begin
    prod <= unsigned(a) * unsigned(b);
    out9 <= std_logic_vector(prod(8 downto 0));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation: flat unsigned compare instead of the
-- reference's bit-cascaded one-bit comparator chain. Same truth table.
entity compar is
    port (
        a, b : in  std_logic_vector(3 downto 0);
        so_a : out std_logic;
        so_b : out std_logic
    );
end compar;

architecture rtl of compar is
begin
    so_a <= '1' when unsigned(a) > unsigned(b) else '0';
    so_b <= '1' when unsigned(b) > unsigned(a) else '0';
end rtl;

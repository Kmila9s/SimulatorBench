library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        b      : in  std_logic_vector(1 downto 0);
        a      : in  std_logic_vector(1 downto 0);
        b_gt   : out std_logic;
        b_a_eq : out std_logic;
        a_gt   : out std_logic
    );
end comparator;

architecture rtl of comparator is
    signal eq1 : std_logic;
    signal eq0 : std_logic;
begin
    eq1 <= not (b(1) xor a(1));
    eq0 <= not (b(0) xor a(0));

    b_a_eq <= eq1 and eq0;
    b_gt   <= (b(1) and not a(1)) or (eq1 and b(0) and not a(0));
    a_gt   <= (a(1) and not b(1)) or (eq1 and a(0) and not b(0));
end rtl;

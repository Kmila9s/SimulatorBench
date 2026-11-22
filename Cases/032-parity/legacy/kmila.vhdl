library ieee;
use ieee.std_logic_1164.all;

entity parity is
    port (
        a : in  std_logic_vector(7 downto 0);
        t : in  std_logic;
        p : out std_logic
    );
end parity;

architecture rtl of parity is
    signal even_parity : std_logic;
begin
    even_parity <= a(7) xor a(6) xor a(5) xor a(4)
               xor a(3) xor a(2) xor a(1) xor a(0);
    p <= even_parity xor t;
end rtl;

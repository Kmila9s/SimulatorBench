library ieee;
use ieee.std_logic_1164.all;

entity xor_gate is
    port (
        a : in  std_logic_vector(7 downto 0);
        b : in  std_logic_vector(7 downto 0);
        c : out std_logic_vector(7 downto 0)
    );
end xor_gate;

architecture rtl of xor_gate is
begin
    c <= a xor b;
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity Gray2BinN is
    port (
        g_i : in  std_logic_vector(3 downto 0);
        b_o : out std_logic_vector(3 downto 0)
    );
end Gray2BinN;

architecture rtl of Gray2BinN is
    signal b : std_logic_vector(3 downto 0);
begin
    b(3) <= g_i(3);
    b(2) <= b(3) xor g_i(2);
    b(1) <= b(2) xor g_i(1);
    b(0) <= b(1) xor g_i(0);
    b_o  <= b;
end rtl;

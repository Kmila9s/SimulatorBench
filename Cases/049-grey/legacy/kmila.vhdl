library ieee;
use ieee.std_logic_1164.all;

entity grey is
    port (
        si : in  std_logic_vector(2 downto 0);
        so : out std_logic_vector(2 downto 0)
    );
end grey;

architecture rtl of grey is
begin
    so(0) <= si(0) xor si(1);
    so(1) <= si(1) xor si(2);
    so(2) <= si(2);
end rtl;

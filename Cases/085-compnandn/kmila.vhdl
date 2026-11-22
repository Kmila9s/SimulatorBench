library ieee;
use ieee.std_logic_1164.all;

entity CompNANDn is
    port (
        entrada_i : in  std_logic_vector(3 downto 0);
        salida_o  : out std_logic
    );
end CompNANDn;

architecture rtl of CompNANDn is
begin
    salida_o <= not (entrada_i(0) and entrada_i(1) and entrada_i(2) and entrada_i(3));
end rtl;

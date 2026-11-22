library ieee;
use ieee.std_logic_1164.all;

entity CompNORn is
    port (
        entrada_i : in  std_logic_vector(3 downto 0);
        salida_o  : out std_logic
    );
end CompNORn;

architecture rtl of CompNORn is
begin
    salida_o <= not (entrada_i(0) or entrada_i(1) or entrada_i(2) or entrada_i(3));
end rtl;

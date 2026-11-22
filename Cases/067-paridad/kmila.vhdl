library ieee;
use ieee.std_logic_1164.all;

entity ParidadN is
    port (
        a_i  : in  std_logic_vector(3 downto 0);
        pp_o : out std_logic;
        pi_o : out std_logic
    );
end ParidadN;

architecture rtl of ParidadN is
    signal odd : std_logic;
begin
    odd  <= a_i(0) xor a_i(1) xor a_i(2) xor a_i(3);
    pi_o <= odd;
    pp_o <= not odd;
end rtl;

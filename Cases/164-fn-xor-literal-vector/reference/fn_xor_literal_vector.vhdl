library ieee;
use ieee.std_logic_1164.all;

entity fn_xor_literal_vector is
    port (
        a : in  std_logic_vector(3 downto 0);
        y : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behaviour of fn_xor_literal_vector is
    function flip(x : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        return x xor "0011";
    end function;
begin
    y <= flip(a);
end architecture;

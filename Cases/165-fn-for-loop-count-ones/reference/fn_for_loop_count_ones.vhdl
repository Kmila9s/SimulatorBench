library ieee;
use ieee.std_logic_1164.all;

entity fn_for_loop_count_ones is
    port (
        a : in  std_logic_vector(3 downto 0);
        b : in  std_logic_vector(3 downto 0);
        y : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behaviour of fn_for_loop_count_ones is
    function bitwise_xor(x : std_logic_vector(3 downto 0);
                        z : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable r : std_logic_vector(3 downto 0);
    begin
        for i in 0 to 3 loop
            r(i) := x(i) xor z(i);
        end loop;
        return r;
    end function;
begin
    y <= bitwise_xor(a, b);
end architecture;

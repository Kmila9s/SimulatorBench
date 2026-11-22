library ieee;
use ieee.std_logic_1164.all;

entity fn_inline_and2 is
    port (
        a : in  std_logic;
        b : in  std_logic;
        y : out std_logic
    );
end fn_inline_and2;

architecture rtl of fn_inline_and2 is
    function and2(x : std_logic; z : std_logic) return std_logic is
    begin
        return x and z;
    end and2;
begin
    y <= and2(a, b);
end rtl;

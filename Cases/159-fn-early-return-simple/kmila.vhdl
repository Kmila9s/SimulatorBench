library ieee;
use ieee.std_logic_1164.all;

entity fn_early_return_simple is
    port (
        sel : in  std_logic;
        a   : in  std_logic;
        b   : in  std_logic;
        y   : out std_logic
    );
end fn_early_return_simple;

architecture rtl of fn_early_return_simple is
    function early(s : std_logic; x : std_logic; z : std_logic) return std_logic is
    begin
        if s = '1' then
            return x;
        end if;
        return z;
    end early;
begin
    y <= early(sel, a, b);
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity fn_inline_mux2 is
    port (
        sel : in  std_logic;
        a   : in  std_logic;
        b   : in  std_logic;
        y   : out std_logic
    );
end fn_inline_mux2;

architecture rtl of fn_inline_mux2 is
    function pick(s : std_logic; x : std_logic; z : std_logic) return std_logic is
    begin
        if s = '1' then
            return x;
        else
            return z;
        end if;
    end pick;
begin
    y <= pick(sel, a, b);
end rtl;

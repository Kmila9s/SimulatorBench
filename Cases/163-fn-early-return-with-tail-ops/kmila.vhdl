library ieee;
use ieee.std_logic_1164.all;

entity fn_early_return_tail_ops is
    port (
        sel : in  std_logic;
        a   : in  std_logic;
        b   : in  std_logic;
        y   : out std_logic
    );
end fn_early_return_tail_ops;

architecture rtl of fn_early_return_tail_ops is
    function compute(s : std_logic; x : std_logic; z : std_logic) return std_logic is
        variable tmp : std_logic;
    begin
        if s = '1' then
            return x;
        end if;
        tmp := z;
        return tmp;
    end compute;
begin
    y <= compute(sel, a, b);
end rtl;

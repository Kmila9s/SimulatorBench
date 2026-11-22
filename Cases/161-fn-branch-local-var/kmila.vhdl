library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fn_branch_local_var is
    port (
        sel : in  std_logic;
        a   : in  std_logic_vector(3 downto 0);
        b   : in  std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end fn_branch_local_var;

architecture rtl of fn_branch_local_var is
    function compute(s : std_logic; x : std_logic_vector(3 downto 0); z : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable tmp : std_logic_vector(3 downto 0);
    begin
        if s = '1' then
            tmp := x;
            return tmp;
        else
            tmp := z;
            return tmp;
        end if;
    end compute;
begin
    y <= compute(sel, a, b);
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fn_early_return_chain is
    port (
        r0 : in  std_logic;
        r1 : in  std_logic;
        r2 : in  std_logic;
        y  : out std_logic_vector(1 downto 0)
    );
end fn_early_return_chain;

architecture rtl of fn_early_return_chain is
    function priority(a : std_logic; b : std_logic; c : std_logic) return std_logic_vector is
    begin
        if a = '1' then
            return "01";
        end if;
        if b = '1' then
            return "10";
        end if;
        if c = '1' then
            return "11";
        end if;
        return "00";
    end priority;
begin
    y <= priority(r0, r1, r2);
end rtl;

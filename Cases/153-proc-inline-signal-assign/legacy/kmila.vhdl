library ieee;
use ieee.std_logic_1164.all;

entity proc_inline_signal_assign is
    port (
        clk : in  std_logic;
        d   : in  std_logic;
        q   : out std_logic
    );
end proc_inline_signal_assign;

architecture rtl of proc_inline_signal_assign is
    procedure latch(signal src : in std_logic; signal tgt : out std_logic) is
    begin
        tgt <= src;
    end latch;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            latch(d, q);
        end if;
    end process;
end rtl;

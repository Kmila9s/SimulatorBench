library ieee;
use ieee.std_logic_1164.all;

entity LatchSR_rstPr is
    port (
        r_i : in  std_logic;
        s_i : in  std_logic;
        q_o : out std_logic
    );
end LatchSR_rstPr;

architecture rtl of LatchSR_rstPr is
    signal q : std_logic := '0';
begin
    process(r_i, s_i)
    begin
        if r_i = '1' then
            q <= '0';
        elsif s_i = '1' then
            q <= '1';
        end if;
    end process;

    q_o <= q;
end rtl;

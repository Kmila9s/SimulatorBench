library ieee;
use ieee.std_logic_1164.all;

entity LatchD is
    port (
        d_i  : in  std_logic;
        le_i : in  std_logic;
        q_o  : out std_logic
    );
end LatchD;

architecture rtl of LatchD is
    signal q : std_logic := '0';
begin
    process(d_i, le_i)
    begin
        if le_i = '1' then
            q <= d_i;
        end if;
    end process;

    q_o <= q;
end rtl;

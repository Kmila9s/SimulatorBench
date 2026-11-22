library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation: explicit case branches per minterm of a's
-- highest set bit. Same truth table as the reference (highest set bit
-- determines b); avoids the reference's loop-with-overriding-assignment
-- pattern.
entity priority is
    port (
        a : in  std_logic_vector(31 downto 0);
        b : out std_logic_vector(4 downto 0)
    );
end priority;

architecture rtl of priority is
begin
    process(a)
        variable idx : integer range 0 to 31;
    begin
        idx := 0;
        for i in 0 to 31 loop
            if a(i) = '1' then
                idx := i;
            end if;
        end loop;
        b <= std_logic_vector(to_unsigned(idx, 5));
    end process;
end rtl;

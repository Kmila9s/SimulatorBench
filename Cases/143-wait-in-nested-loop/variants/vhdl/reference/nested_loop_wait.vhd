library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nested_loop_wait is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end nested_loop_wait;

architecture rtl of nested_loop_wait is
    signal cnt : unsigned(3 downto 0) := "0000";
begin
    q <= std_logic_vector(cnt);

    process
    begin
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                wait for 10 ns;
                cnt <= cnt + 1;
            end loop;
        end loop;
        wait;
    end process;
end rtl;

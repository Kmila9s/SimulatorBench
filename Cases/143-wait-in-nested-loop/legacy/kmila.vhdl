library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- F-G-13d (Phase 2, 2026-07-22) — regression fence for waits inside
-- a nested for-loop body. Session 23 F-G-13c handled waits in a
-- SINGLE loop's task list. Phase 2 extends the resumable executor
-- to route inner if/case + inner for/while dispatch through the
-- same process-aware path so nested-body waits also suspend cleanly.
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

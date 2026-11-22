library ieee;
use ieee.std_logic_1164.all;

-- F-G-13d (Phase 2, 2026-07-22) — regression fence for waits inside
-- an `if` branch body. Pre-fix, IfStructure.SyntetizeBranchBody
-- silently dropped `wait` at parse time via
-- ParseTrace.SkipWaitStatement — the process ran through its
-- if-body without any yield, so `q` slammed to its post-wait value
-- at time 0 instead of stepping at 20/30 ns cadence.
--
-- Uses an explicit for-loop wrapping the if so the iteration count
-- is fixed (6 iterations); GHDL and Kmila agree on the exact number
-- of transitions regardless of process-implicit-loop cadence.
entity if_wait is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end if_wait;

architecture rtl of if_wait is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
    begin
        for i in 0 to 5 loop
            if state = '0' then
                wait for 20 ns;
                state <= '1';
            else
                wait for 10 ns;
                state <= '0';
            end if;
        end loop;
        wait;
    end process;
end rtl;

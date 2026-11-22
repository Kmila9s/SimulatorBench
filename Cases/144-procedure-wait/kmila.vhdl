library ieee;
use ieee.std_logic_1164.all;

-- Phase 3 (Session 26, 2026-07-22) — regression fence for `wait for N ns`
-- INSIDE a procedure body. Pre-fix, ProcedureCallStatement.ExecuteAsync
-- walked `def.BodyRaw` as a flat token stream and only dispatched
-- `report` + `<=`. Every other token (including `wait`) fell through
-- silently: the caller process ran through the entire procedure body
-- in zero time and `q` slammed to its post-wait value at t=0.
--
-- Fix: ResolveBoundBody rebuilds the procedure body per call (with
-- formals textually renamed to actuals), pushes a ProcedureFrame on the
-- Process.Frames stack, and RunProcedureFromFrameAsync yields the whole
-- process at a WaitForStatement inside the body — the caller resumes
-- past the wait when the timed wake fires.
entity procedure_wait is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end procedure_wait;

architecture rtl of procedure_wait is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
        procedure toggle_after (signal s : inout std_logic) is
        begin
            wait for 20 ns;
            if s = '0' then
                s <= '1';
            else
                s <= '0';
            end if;
        end procedure;
    begin
        for i in 0 to 5 loop
            toggle_after(state);
        end loop;
        wait;
    end process;
end rtl;
